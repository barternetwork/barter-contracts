// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "./interface/IERC20.sol";
import "./libs/TransferHelper.sol";
import "./libs/SafeMath.sol";
import "./interface/ISwap.sol";
import "./interface/IWETH9.sol";
import "./interface/IBarterswapV2Router01.sol";



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
        // address    inputAddre; 
        // address    outAddre; 
        address[]  input_Out_addre;  // 0 -input  1- Out
        uint256[]  routerIndex; 
        address[9][2] crv_Route;
        uint256[3][4] crv_Swap_Params;
        uint256       crv_expected;
                     
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
                }else{

                    ammSeriSwap(rindex,params.amountInArr[i],params.amountOutMinArr[i],params.pathArr[i],params.to,params.deadLine,params.input_Out_addre[0],params.input_Out_addre[1]);
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
            // IERC20(_inputAddre).approve(_rindex,_amount);
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