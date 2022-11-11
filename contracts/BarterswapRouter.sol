// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "./interface/IERC20.sol";
import "./libs/TransferHelper.sol";
import "./libs/SafeMath.sol";
import "./interface/ISwap.sol";
import "./interface/IBalancerSwap/IAsset.sol";
import "./interface/IBalancerSwap/IVault.sol";
import "./interface/IWETH9.sol";
import "./interface/IBarterswapV2Router01.sol";



contract BarterswapRouterV1  {
    using SafeMath for uint;
   
    address  payable public  feeTo; 
    address public feeToAdmin; 
    uint public fees; 
    mapping(uint256 => address) public routerAddreAll;
    address constant WETHS = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

   

   struct AccessParams {
        uint256[]  amountInArr;  
        uint256[]  amountOutMinArr;
        bytes[]    pathArr;
        address  payable  to; 
        uint256    deadLine; 
        // address    inputAddre; 
        // address    outAddre; 
        address[]  input_Out_addre;  // 0 -input  1- Out
        uint256[]  routerIndex; 
        address[9][2] crv_Route;
        uint256[3][4] crv_Swap_Params;
        uint256       crv_expected;
        uint256    min_received;
        IVault.BatchSwapStep[]  batchSwapSteps;
        IVault.FundManagement fundManaGements;
        int256[]      limits;
        IAsset[]       assets;
        IVault.SwapKind _kind;              
    } 
    


     receive() external payable { 
    }
 

    modifier onlyOwner() {
        require(msg.sender == feeToAdmin,"BarterswapV2Router: EXPIRED");
        _;
    }

    constructor(address _feeToAdmin) {
        feeToAdmin = _feeToAdmin;
    }

    

    function multiSwap (AccessParams calldata params) external payable {    
            uint256 amountInArrs = getAmountInAll(params.amountInArr);
            uint256 toFees = amountInArrs.mul(fees).div(1e18);

            if(params.input_Out_addre[0] == address(0)){
                require(msg.value == amountInArrs+toFees,"Price is wrong");
                TransferHelper.safeTransferETH(feeTo,toFees);
            }else{ 
                TransferHelper.safeTransferFrom(params.input_Out_addre[0],msg.sender,address(this),amountInArrs);
                TransferHelper.safeTransferFrom(params.input_Out_addre[0],msg.sender,feeTo,toFees); 
            }
            

            for(uint i = 0; i < params.routerIndex.length; i++){
                address rindex = routerAddreAll[params.routerIndex[i]];
                if (i == 0  && params.crv_expected != 0){
                    
                    crvSwap(params.input_Out_addre[0],rindex,params.crv_Route,params.crv_Swap_Params,params.amountInArr[i],params.crv_expected,params.to);
                }else if(i == 1 && params.limits.length > 0){
                     
                    balancerSwap(params._kind,params.input_Out_addre[0],rindex,params.batchSwapSteps,params.fundManaGements,params.assets,params.limits,params.deadLine);   

                }else{

                    ammSeriSwap(rindex,params.amountInArr[i],params.amountOutMinArr[i],params.pathArr[i],params.to,params.deadLine,params.input_Out_addre[0],params.input_Out_addre[1]);

                    }
                }
            }


    
    // balancer
       
    function balancerSwap(IVault.SwapKind _kind, address _inputAddre,address _rindex,IVault.BatchSwapStep[] memory _swaps,IVault.FundManagement memory _funds, IAsset[] memory  _assets, int256[]  memory _limit,uint256 _deadLine) internal{
        if(_inputAddre == address(0)){
            TransferHelper.safeTransferETH(_rindex,_swaps[0].amount);
            ISwap(_rindex).filterBalancer(_kind,_swaps,_funds,_assets,_limit,_deadLine);
        }else{
            TransferHelper.safeApprove(_inputAddre,_rindex,_swaps[0].amount);
            // IERC20(_rindex).approve(_rindex,_swaps[0].amount);
            TransferHelper.safeTransfer(_inputAddre,_rindex,_swaps[0].amount);
            ISwap(_rindex).filterBalancer(_kind,_swaps,_funds,_assets,_limit,_deadLine);
        }
    }
    

    
    // crv
    function crvSwap(address _inputAddre,address  _rindex, address[9][2] memory _route,uint256[3][4] memory _swap_params,uint256 _amount, uint256 expected,address _to) internal{
        
        address[4] memory pools;                
        pools[0] = _route[1][0];
        pools[1] = _route[1][1];
        pools[2] = _route[1][2];
        pools[3] = _route[1][3];


        address[9] memory route;
        route[0] = _route[0][0];
        route[1] = _route[0][1];
        route[2] = _route[0][2];
        route[3] = _route[0][3];
        route[4] = _route[0][4];
        route[5] = _route[0][5];
        route[6] = _route[0][6];
        route[7] = _route[0][7];
        route[8] = _route[0][8];
        
        uint256[3][4] memory swap_params;
        swap_params[0] = _swap_params[0];
        swap_params[1] = _swap_params[1];
        swap_params[2] = _swap_params[2];
        swap_params[3] = _swap_params[3];

        if(_inputAddre == address(0)){
             TransferHelper.safeTransferETH(_rindex,_amount);   
             ISwap(_rindex).filterCurve(_inputAddre,route,swap_params,_amount,expected,pools,_to);
         }else{
             TransferHelper.safeApprove(_inputAddre,_rindex,_amount);
            // IERC20(_inputAddre).approve(_rindex,_amount);
            TransferHelper.safeTransfer(_inputAddre,_rindex,_amount);
            ISwap(_rindex).filterCurve(_inputAddre,route,swap_params,_amount,expected,pools,_to);
         } 
    }


    // uni kind
    function ammSeriSwap(address _rindex,uint256 _amount,uint256 _amountOutMinArr,bytes memory _pathArr,address _to,uint256 _deadLine,address _inputAddre,address _outAddre) internal {
            if(_inputAddre == address(0)){
                    TransferHelper.safeTransferETH(_rindex,_amount);
                    ISwap(_rindex).filterSwap(_amount,_amountOutMinArr,_pathArr,_to,_deadLine,_inputAddre,_outAddre);      
                }else{
                    TransferHelper.safeApprove(_inputAddre,_rindex,_amount);
                    // IERC20(_rindex).approve(_rindex,_amountInArr);
                    TransferHelper.safeTransfer(_inputAddre,_rindex,_amount);
                    ISwap(_rindex).filterSwap(_amount,_amountOutMinArr,_pathArr,_to,_deadLine,_inputAddre,_outAddre);     
                }
    }

    
    // amountInArr
    function getAmountInAll(uint256[] memory  amountInArr) public pure  returns(uint256 ){
        uint256 amountInArrs;
        for(uint256 i = 0; i < amountInArr.length; i++){
            amountInArrs += amountInArr[i];
        }
        return amountInArrs;
    }


    // swapweth
    function ethToWeth(uint256 amountin, address _to) public payable {
            uint256 toFees = amountin.mul(fees).div(1e18);
            require(msg.value == amountin + toFees,"Price is wrong");
            TransferHelper.safeTransferETH(feeTo,toFees);
            IWETH9(WETHS).deposit{value:amountin}();  
            TransferHelper.safeTransfer(WETHS,_to,amountin);
    }


    function setFeeTo(address payable _feeTo) public onlyOwner returns(bool) {
        require(_feeTo != address(0), 'Barterswap: FORBIDDEN');
        feeTo = _feeTo;
        return true;
    }

    

    function setFeeToSetter(address _feetoAdmin) public onlyOwner returns(bool) {
         require(_feetoAdmin != address(0), 'Barterswap: FORBIDDEN');
        feeToAdmin = _feetoAdmin;
        return true;
    }
    

     function setFees(uint _fees) public onlyOwner returns(bool) {
        require(_fees != 0, 'Barterswap: FORBIDDEN');
        fees = _fees;
        return true;
    }
    


    function setRouterAddreAll(uint256 index ,address _routeraddre) public onlyOwner returns(bool){
        require(_routeraddre != address(0),'Barterswap: FORBIDDEN');
        routerAddreAll[index] = _routeraddre;
        return true;
    }


    function getWeth(address _routerArr) public pure returns(address WETH){
        WETH =  IBarterswapV2Router01(_routerArr).WETH(); 
    }
  
}