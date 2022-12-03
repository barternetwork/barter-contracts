
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "../interface/ISwap.sol";
import "../interface/IERC20.sol";
import "../libs/TransferHelper.sol";
import "hardhat/console.sol"; 
import "../interface/ICurveRouter.sol";





contract CurvePool_Swap_Test{

    address public constant CURVE_SWAP  = 0x55B916Ce078eA594c10a874ba67eCc3d62e29822;




    function filterSwap(bytes memory  exchangeData)  payable external{
        address inputAddre;
        address[9] memory route;
        uint256[3][4] memory swap_params;
        uint256 amount;
        uint256 expected;
        address[4] memory pools;
        address receiver;
       (inputAddre,route,swap_params,amount,expected,pools,receiver)  = abi.decode(exchangeData,(address,address[9],uint256[3][4],uint256,uint256,address[4],address));
        exchange_Multiples(inputAddre,route,swap_params,amount,expected,pools,receiver);
    }


    function exchange_Multiples(address inputAddre,address[9] memory route,uint256[3][4] memory swap_params,uint256 amount,uint256 expected,address[4] memory pools,address receiver) internal  {
     if (inputAddre == address(0)){
         require(msg.value == amount,"Price is wrong");
         ICurveRouter(CURVE_SWAP).exchange_multiple{value:amount}(route,swap_params,amount,expected,pools,receiver);
     }else{
        TransferHelper.safeTransferFrom(inputAddre,msg.sender,address(this),amount);
        TransferHelper.safeApprove(inputAddre,CURVE_SWAP,amount);
        ICurveRouter(CURVE_SWAP).exchange_multiple(route,swap_params,amount,expected,pools,receiver);
         }    
    }



     function get_best_rates(address from,address to,uint256 amount) external view returns(address,uint256){
        address addreto;
        uint256 addreyint;

       (addreto,addreyint)= ICurveRouter(CURVE_SWAP).get_best_rate(from,to,amount);
        return (addreto,addreyint);


     }

}

