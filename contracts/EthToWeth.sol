
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "./interface/IWETH9.sol";
import "./libs/TransferHelper.sol";
contract ethExchangeWeth{
     // swapweth

    address constant WETHS = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    function ethToWeth(uint256 amountin, address _to) public payable {
         require(msg.value == amountin,"Price is wrong");
            IWETH9(WETHS).deposit{value:amountin}();  
            TransferHelper.safeTransfer(WETHS,_to,amountin);
    }

} 