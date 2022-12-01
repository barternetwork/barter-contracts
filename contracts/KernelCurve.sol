
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "./interface/ISwap.sol";
import "./interface/IERC20.sol";
import "./libs/TransferHelper.sol";
import "./interface/ICurveRouter.sol";





contract curvePool_Swap{

    address public constant CURVE_SWAP  = 0x55B916Ce078eA594c10a874ba67eCc3d62e29822;

    function filterCurve( address inputAddre,address[9] memory route,uint256[3][4] memory swap_params,uint256 amount,uint256 expected,address[4] memory pools,address receiver)  payable external{
        exchange_Multiples(inputAddre,route,swap_params,amount,expected, pools,receiver);
    }


    function exchange_Multiples( address _inputAddre,address[9] memory _route,uint256[3][4] memory _swap_params,uint256 _amount,uint256 _expected,address[4] memory _pools,address _receiver)  internal  returns(uint256){
     uint256  received_Token;
     TransferHelper.safeApprove(_inputAddre,CURVE_SWAP,_amount);
    received_Token =  ICurveRouter(CURVE_SWAP).exchange_multiple(_route,_swap_params,_amount,_expected,_pools,_receiver);
     return received_Token;
    }

}

