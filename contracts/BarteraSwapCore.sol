// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "./interface/IERC20.sol";
import "./libs/TransferHelper.sol";
import "./libs/SafeMath.sol";
import "./interface/ISwap.sol";
import "./interface/IWETH9.sol";



contract ButterExchange  {

    using SafeMath for uint;
    address public feeToAdmin; 
    mapping(uint256 => address) public routerAddreAll;
   

   struct AccessParams {
        uint256[]  amountInArr;  
        uint256[]  amountOutMinArr;
        bytes[]    pathArr;
        address  payable  to; 
        uint256    deadLine; 
        address[]  inputOutAddre;  // 0 -input  1- Out
        uint256[]  routerIndex; 
        address[9][2] crvRoute;
        uint256[3][4] crvSwapParams;
        uint256       crvExpected;                   
    } 
    

     receive() external payable { 
    }
 

    modifier onlyOwner() {
        require(msg.sender == feeToAdmin,"ButterswapV2Router: EXPIRED");
        _;
    }

    constructor(address _feeToAdmin) {
        feeToAdmin = _feeToAdmin;
    }

    

    function multiSwap (AccessParams calldata params) external payable {    
            uint256 amountInArrs = getAmountInAll(params.amountInArr);
            if(params.inputOutAddre[0] == address(0)){
                require(msg.value == amountInArrs,"Price is wrong");
            }else{ 
                TransferHelper.safeTransferFrom(params.inputOutAddre[0],msg.sender,address(this),amountInArrs);
            }
            
            for(uint i = 0; i < params.routerIndex.length; i++){
                address rindex = routerAddreAll[params.routerIndex[i]];
                if (i == 0  && params.crvExpected != 0){ 
                    crvSwap(params.inputOutAddre[0],rindex,params.crvRoute,params.crvSwapParams,params.amountInArr[i],params.crvExpected,params.to);
                }else{
                    ammSeriSwap(rindex,params.amountInArr[i],params.amountOutMinArr[i],params.pathArr[i],params.to,params.deadLine,params.inputOutAddre[0],params.inputOutAddre[1]);                  
                    }
                }
            }


    // crv
    function crvSwap(address _inputAddre,address  _rindex, address[9][2] memory _route,uint256[3][4] memory _swap_params,uint256 _amount, uint256 expected,address _to) internal{
        
        address[4] memory pools;                
        pools[0] = _route[1][0];
        pools[1] = _route[1][1];
        pools[2] = _route[1][2];
        pools[3] = _route[1][3];

        if(_inputAddre == address(0)){
             TransferHelper.safeTransferETH(_rindex,_amount);   
             ISwap(_rindex).filterCurve(_inputAddre,_route[0],_swap_params,_amount,expected,pools,_to);
         }else{
             TransferHelper.safeApprove(_inputAddre,_rindex,_amount);
            TransferHelper.safeTransfer(_inputAddre,_rindex,_amount);
            ISwap(_rindex).filterCurve(_inputAddre,_route[0],_swap_params,_amount,expected,pools,_to);
         } 
    }


    // uni kind
    function ammSeriSwap(address _rindex,uint256 _amount,uint256 _amountOutMinArr,bytes memory _pathArr,address _to,uint256 _deadLine,address _inputAddre,address _outAddre) internal {
            if(_inputAddre == address(0)){
                    TransferHelper.safeTransferETH(_rindex,_amount);
                    ISwap(_rindex).filterSwap(_amount,_amountOutMinArr,_pathArr,_to,_deadLine,_inputAddre,_outAddre);      
                }else{
                    TransferHelper.safeApprove(_inputAddre,_rindex,_amount);
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



    function setFeeToSetter(address _feetoAdmin) public onlyOwner returns(bool) {
         require(_feetoAdmin != address(0), 'Butterswap: FORBIDDEN');
        feeToAdmin = _feetoAdmin;
        return true;
    }
    


    function setRouterAddreAll(uint256 index ,address _routeraddre) public onlyOwner returns(bool){
        require(_routeraddre != address(0),'Butterswap: FORBIDDEN');
        routerAddreAll[index] = _routeraddre;
        return true;
    }


  
}