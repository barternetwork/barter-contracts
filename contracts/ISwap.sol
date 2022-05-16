// SPDX-License-Identifier: MIT

pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;



interface ISwap{

    function filterSwap(uint256  amountInArr,uint256  amountOutMinArr,bytes memory pathArr,address to,uint256 deadLine,address inputAddre,address outAddre) external payable;

    function filterCurve(address to,address inputAddre,uint256[] memory _crvParams) external;
}
