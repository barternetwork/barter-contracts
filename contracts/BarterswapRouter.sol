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

    address public feeToAdmin; 

    mapping(uint256 => address) public routerAddreAll;
   

   struct AccessParams {
        uint256[]  amountInArr;  
        bytes[]    paramsArr;
        uint32[]  routerIndex; 
        address[2]  input_Out_Addre; 
         // 0 -input  1- Out                     
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

            if(params.input_Out_Addre[0] == address(0)){
                require(msg.value == amountInArrs,"Price is wrong");
            }else{ 
                TransferHelper.safeTransferFrom(params.input_Out_Addre[0],msg.sender,address(this),amountInArrs);
            }
            
            for(uint i = 0; i < params.routerIndex.length; i++){

                address swapIndex = routerAddreAll[params.routerIndex[i]];
                  if(params.input_Out_Addre[0] == address(0)){
                      TransferHelper.safeTransferETH(swapIndex,params.amountInArr[i]); 
                      ISwap(swapIndex).filterSwap(params.paramsArr[i]);
                  }else{

                      TransferHelper.safeApprove(params.input_Out_Addre[0],swapIndex,params.amountInArr[i]);
                      TransferHelper.safeTransfer(params.input_Out_Addre[0],swapIndex,params.amountInArr[i]);
                      ISwap(swapIndex).filterSwap(params.paramsArr[i]);
                  }
            }
                 
        }    


    function getAmountInAll(uint256[] memory amountInArr) public pure  returns(uint256 ){
        uint256 amountInArrs;
        for(uint256 i = 0; i < amountInArr.length; i++){
            amountInArrs += amountInArr[i];
        }
        return amountInArrs;
    }




    function updateAdmin(address adminAddre) public onlyOwner returns(bool) {
         require(adminAddre != address(0), 'Barterswap: FORBIDDEN');
        feeToAdmin = adminAddre;
        return true;
    }
    


    function setRouterAddreAll(uint256 index ,address _routeraddre) public onlyOwner returns(bool){
        require(_routeraddre != address(0),'Barterswap: FORBIDDEN');
        routerAddreAll[index] = _routeraddre;
        return true;
    }

    receive() external payable { 
    }

}