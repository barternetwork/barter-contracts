// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;


import "./IBalancerSwap/IAsset.sol";
import "./IBalancerSwap/IVault.sol";

interface ISwap{


    // AMMSWAP
    function filterSwap(uint256  amountInArr,uint256  amountOutMinArr,bytes memory pathArr,address to,uint256 deadLine,address inputAddre,address outAddre) external payable;


    //CurveSwap
    // function filterCurve(uint256 _amount,address inputAddre,address[6] memory _route, uint256[8] memory _indices,uint256 _min_received,address _to) external  payable;

    function filterCurve(address inputAddre,address[9] memory route,uint256[3][4] memory swap_params,uint256 _amount,uint256 expected,address[4] memory pools,address receiver) external  payable;

    //BalancerSwap
    function filterBalancer(IVault.SwapKind kind,IVault.BatchSwapStep[] memory swaps,IVault.FundManagement memory funds, IAsset[] memory  assets, int256[]  memory limit,uint256 deadline) external payable;
}
