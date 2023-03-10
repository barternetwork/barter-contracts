// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "../interface/IWETH9.sol";

contract WrapNativeToken {
    // swapweth

    address immutable WToken;

    constructor(address _wrapNative) {
        require(_wrapNative != address(0) && _wrapNative.code.length > 0);

        WToken = _wrapNative;
    }

    function ethToWeth(uint256 amountin, address _to) public payable {
        require(msg.value == amountin, "Price is wrong");
        IWETH9(WToken).deposit{value: amountin}();
        SafeERC20.safeTransfer(IWETH9(WToken), _to, amountin);
    }


}
