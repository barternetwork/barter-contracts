// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;


import "./interface/IBalancerSwap/IAsset.sol";
import "./interface/IBalancerSwap/IVault.sol";

interface ISwap{


    // AMMSWAP
    function filterSwap(uint256  amountInArr,uint256  amountOutMinArr,bytes memory pathArr,address to,uint256 deadLine,address inputAddre,address outAddre) external payable;


    //CurveSwap
    function filterCurve(address to,address inputAddre,uint256[] memory _crvParams) external;


    //BalancerSwap
    function filterBalancer(IVault.SwapKind kind,IVault.BatchSwapStep[] memory swaps,IVault.FundManagement memory funds, IAsset[] memory  assets, int256[]  memory limit,uint256 deadline) external payable;
}
