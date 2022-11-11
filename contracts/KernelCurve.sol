
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "./interface/ISwap.sol";
import "./interface/IERC20.sol";
import "./libs/TransferHelper.sol";




interface ICurveFiCurve {

   function get_best_rate(address from,address to,uint256 amount) external view returns(address,uint256);

    function exchange_multiple(address[9] memory _route,uint256[3][4] memory _swap_params,uint256 _amount,uint256 _expected,address[4] memory _pools,address _receiver)payable external  returns(uint256);
}


contract CurvePool_Swap{

    address public constant CURVE_SWAP  = 0x55B916Ce078eA594c10a874ba67eCc3d62e29822;
    function exchange_Multiple( address inputAddre,address[9] memory route,uint256[3][4] memory swap_params,uint256 amount,uint256 expected,address[4] memory pools,address receiver)  payable external returns(uint256){
     uint256  received_Token;
     TransferHelper.safeApprove(inputAddre,CURVE_SWAP,amount);
     received_Token =  ICurveFiCurve(CURVE_SWAP).exchange_multiple(route,swap_params,amount,expected,pools,receiver);
     return received_Token;
    }
    
}

