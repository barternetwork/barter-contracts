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
        address    inputAddre; 
        address    outAddre; 
        uint256[]  routerIndex; 
        address[6] croute;
        uint256[8] induces;
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

            if(params.inputAddre == address(0)){
                require(msg.value == amountInArrs+toFees,"Price is wrong");
                TransferHelper.safeTransferETH(feeTo,toFees);
            }else{ 
                TransferHelper.safeTransferFrom(params.inputAddre,msg.sender,address(this),amountInArrs);
                TransferHelper.safeTransferFrom(params.inputAddre,msg.sender,feeTo,toFees); 
            }

            for(uint i = 0; i < params.routerIndex.length; i++){
                address rindex = routerAddreAll[params.routerIndex[i]];
                if (i == 0  && params.induces.length == 8){
                    
                    crvSwap(rindex,params.amountInArr[i],params.inputAddre,params.croute,params.induces,params.min_received,params.to);
                }else if(i == 1 && params.limits.length > 1){
                     
                    balancerSwap(params._kind,params.inputAddre,rindex,params.batchSwapSteps,params.fundManaGements,params.assets,params.limits,params.deadLine);   

                }else{
                    ammSeriSwap(rindex,params.amountInArr[i],params.amountOutMinArr[i],params.pathArr[i],params.to,params.deadLine,params.inputAddre,params.outAddre);
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

    function crvSwap(address  _rindex,  uint256 _amount,address _inputAddre,address[6] memory _route, uint256[8] memory _indices,uint256 _min_Received,address _to) internal{
        
         if(_inputAddre == address(0)){
             TransferHelper.safeTransferETH(_rindex,_amount);   
             ISwap(_rindex).filterCurve(_amount,_inputAddre,_route,_indices,_min_Received,_to);
         }else{
             TransferHelper.safeApprove(_inputAddre,_rindex,_amount);
            // IERC20(_inputAddre).approve(_rindex,_amount);
            TransferHelper.safeTransfer(_inputAddre,_rindex,_amount);
            ISwap(_rindex).filterCurve(_amount,_inputAddre,_route,_indices,_min_Received,_to);
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