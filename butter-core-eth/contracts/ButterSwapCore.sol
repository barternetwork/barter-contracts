// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "./interface/IERC20.sol";
import "./libs/TransferHelper.sol";
import "./libs/SafeMath.sol";
import "./interface/ISwap.sol";



contract ButterExchange  {

    using SafeMath for uint;

    address public admin; 

    mapping(uint256 => address) public indexAddressAll;
   
    mapping (address=>uint256) public addressIndexAll;

   event MultiSwap(bytes32 indexed orderId,address indexed from,address inputToken,uint256 inputAmount,address outputToken,uint256 outputAmount);

   struct AccessParams {
        uint256[]  amountInArr;  
        bytes[]    paramsArr;
        uint32[]  routerIndex; 
        address[2]  inputOutAddre; // 0 -input  1- Out                        
    } 
    
       modifier onlyOwner() {
        require(msg.sender == admin,"Caller is not an owner");
        _;
    }

    constructor(address _admin) {
        admin = _admin;
    }


    function multiSwap (bytes32 orderId,AccessParams calldata params) external payable {    

            uint256 amountInArrs = getAmountInAll(params.amountInArr);

            if(params.inputOutAddre[0] == address(0)){
                require(msg.value == amountInArrs,"Price is wrong");
            }else{ 

                TransferHelper.safeTransferFrom(params.inputOutAddre[0],msg.sender,address(this),amountInArrs);
            }
            uint256 amountOut; 
            for(uint i = 0; i < params.routerIndex.length; i++){

                address swapIndex = indexAddressAll[params.routerIndex[i]];

                  if(params.inputOutAddre[0] == address(0)){
                      TransferHelper.safeTransferETH(swapIndex,params.amountInArr[i]); 
                      amountOut += ISwap(swapIndex).filterSwap(params.paramsArr[i]);
                  }else{   
                      TransferHelper.safeApprove(params.inputOutAddre[0],swapIndex,params.amountInArr[i]);
                      TransferHelper.safeTransfer(params.inputOutAddre[0],swapIndex,params.amountInArr[i]);
                      amountOut += ISwap(swapIndex).filterSwap(params.paramsArr[i]);          
                  }
            }
            emit MultiSwap(orderId,msg.sender,params.inputOutAddre[0],amountInArrs,params.inputOutAddre[1],amountOut); 
        }    


    function getAmountInAll(uint256[] memory amountInArr) public pure  returns(uint256 ){
        uint256 amountInArrs;
        for(uint256 i = 0; i < amountInArr.length; i++){
            amountInArrs += amountInArr[i];
        }
        return amountInArrs;
    }



    function updateAdmin(address adminAddre) public onlyOwner returns(bool) {
         require(adminAddre != address(0), 'Address is 0');
        admin = adminAddre;
        return true;
    }
    

   function setRouterAddreAll(uint256 index ,address _routerAddre) public onlyOwner returns(bool){
        require(_routerAddre != address(0),'Address is 0');
        indexAddressAll[index] = _routerAddre;
        addressIndexAll[_routerAddre] = index;
        return true;
    }

    receive() external payable { 
    }


}