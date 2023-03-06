// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;
pragma experimental ABIEncoderV2;


interface IButterCore {

    struct AccessParams {
        uint256[] amountInArr;
        bytes[] paramsArr;
        uint32[] routerIndex;
        address[2] inputOutAddre;  // 0 -input  1- Out
    }

    function multiSwap(AccessParams calldata params) external payable returns(uint256);
}


