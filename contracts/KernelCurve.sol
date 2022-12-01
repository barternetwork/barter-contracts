
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "./interface/ISwap.sol";
import "./interface/IERC20.sol";
import "./libs/TransferHelper.sol";
import "./interface/ICurveRouter.sol";


// (address _inputAddre,address  _rindex, address[9][2] memory _route,uint256[3][4] memory _swap_params,uint256 _amount, uint256 expected,address _to
// address inputAddre,address[9][2] memory route,uint256[3][4] memory swap_params,uint256 amount,uint256 expected,address[4] memory pools,address receiver

contract curvePool_Swap{

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


    function exchange_Multiples( address _inputAddre,address[9] memory _route,uint256[3][4] memory _swap_params,uint256 _amount,uint256 _expected,address[4] memory _pools,address _receiver)  internal {
     
     if(_inputAddre == address(0)){
          ICurveRouter(CURVE_SWAP).exchange_multiple{value: _amount}(_route,_swap_params,_amount,_expected,_pools,_receiver);
     }else{
         TransferHelper.safeApprove(_inputAddre,CURVE_SWAP,_amount);
         ICurveRouter(CURVE_SWAP).exchange_multiple(_route,_swap_params,_amount,_expected,_pools,_receiver);

     }
     
    }

}

