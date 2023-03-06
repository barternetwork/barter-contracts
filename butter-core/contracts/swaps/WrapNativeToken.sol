
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "../interface/IWETH9.sol";
import "../libs/TransferHelper.sol";
contract WrapNativeToken{
     // swapweth

    address immutable WToken;

    constructor(address _wrapNative) {
          require(_wrapNative != address(0) && _wrapNative.code.length > 0);

          WToken = _wrapNative;
    }

    function ethToWeth(uint256 amountin, address _to) public payable {
         require(msg.value == amountin,"Price is wrong");
            IWETH9(WToken).deposit{value:amountin}();  
            TransferHelper.safeTransfer(WToken,_to,amountin);
    }

} 