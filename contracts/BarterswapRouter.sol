// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "./interface/IERC20.sol";
import "./libs/TransferHelper.sol";
import "./libs/SafeMath.sol";
import "./ISwap.sol";
import "./interface/IBalancerSwap/IAsset.sol";
import "./interface/IBalancerSwap/IVault.sol";





contract BarterswapRouterV1  {
    using SafeMath for uint;
   
    address  payable public  feeTo; 
    address public feeToAdmin; 
    uint public fees; 

    mapping(uint256 => address) public routerAddreAll;


   

   struct AccessParams {
        uint256[]  amountInArr;
        uint256[]  amountOutMinArr;
        bytes[]    pathArr;
        address  payable  to;
        uint256    deadLine;
        address    inputAddre;
        address    outAddre;
        uint256[]  routerIndex;
        uint256[]  crvParams;
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
                TransferHelper.safeTransferFrom(params.inputAddre,msg.sender,address(this),amountInArrs );
                TransferHelper.safeTransferFrom(params.inputAddre,msg.sender,feeTo,toFees); 
            }

            

            for(uint i = 0; i < params.routerIndex.length; i++){
                address rindex = routerAddreAll[params.routerIndex[i]];
                if (i == 0 && params.crvParams.length == 4){
                        crvSwap(params.inputAddre,rindex,params.to,params.crvParams[2],params.crvParams);
                 }else if(i == 1 && params.limits.length > 1){
                    
                         balancerSwap(params._kind,params.inputAddre,rindex,params.batchSwapSteps,params.fundManaGements,params.assets,params.limits,params.deadLine);   

                    }else{
    
                        AmmSeriSwap(rindex,params.amountInArr[i],params.amountOutMinArr[i],params.pathArr[i],params.to,params.deadLine,params.inputAddre,params.outAddre);
                    }
                }
        }
    
       
    function balancerSwap(IVault.SwapKind _kind, address _inputAddre,address _rindex,IVault.BatchSwapStep[] memory _swaps,IVault.FundManagement memory _funds, IAsset[] memory  _assets, int256[]  memory _limit,uint256 _deadLine) internal{
        if(_inputAddre == address(0)){
            TransferHelper.safeTransferETH(_rindex,_swaps[0].amount);
            ISwap(_rindex).filterBalancer(_kind,_swaps,_funds,_assets,_limit,_deadLine);
        }else{
            IERC20(_rindex).approve(_rindex,_swaps[0].amount);
            TransferHelper.safeTransfer(_inputAddre,_rindex,_swaps[0].amount);
            ISwap(_rindex).filterBalancer(_kind,_swaps,_funds,_assets,_limit,_deadLine);
        }
    }
    


    function crvSwap(address _inputAddre,address _rindex,address _to,uint256 _dx,uint256[] memory parameterList) internal{
        IERC20(_inputAddre).approve(_rindex,_dx);
        TransferHelper.safeTransfer(_inputAddre,_rindex,_dx);
        ISwap(_rindex).filterCurve(_to,_inputAddre,parameterList);
        
    }


    function AmmSeriSwap(address _rindex,uint256 _amountInArr,uint256 _amountOutMinArr,bytes memory _pathArr,address _to,uint256 _deadLine,address _inputAddre,address _outAddre) internal {
            if(_inputAddre == address(0)){
                    TransferHelper.safeTransferETH(_rindex,_amountInArr);
                    ISwap(_rindex).filterSwap(_amountInArr,_amountOutMinArr,_pathArr,_to,_deadLine,_inputAddre,_outAddre);      
                }else{
                    IERC20(_rindex).approve(_rindex,_amountInArr);
                    TransferHelper.safeTransfer(_inputAddre,_rindex,_amountInArr);
                    ISwap(_rindex).filterSwap(_amountInArr,_amountOutMinArr,_pathArr,_to,_deadLine,_inputAddre,_outAddre);     
                }
    }
    


    function getAmountInAll(uint256[] memory  amountInArr) public pure returns(uint256){
        uint amountInArrs;
        for(uint i = 0; i < amountInArr.length; i++){
            amountInArrs += amountInArr[i];
        }
        return amountInArrs ;
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


  
}