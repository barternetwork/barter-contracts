// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "../interface/ISwap.sol";
import "../interface/IERC20.sol";
import "../interface/IUniRouter01.sol";
import "../libs/TransferHelper.sol";
import "../libs/SafeMath.sol";

contract UniV2ForkSwap is ISwap {
    address public immutable swapRouter;

    //
    constructor(address _swapRouter) {
        require(_swapRouter != address(0) && _swapRouter.code.length > 0);

        swapRouter = _swapRouter;
    }

    function filterSwap(
        bytes memory exchangeData
    ) external payable override returns (uint256) {
        uint256 amountInArr;
        uint256 amountOutMinArr;
        address[] memory pathArr;
        address to;
        uint256 deadLines;
        address inputAddre;
        address outAddre;
        (
            amountInArr,
            amountOutMinArr,
            pathArr,
            to,
            deadLines,
            inputAddre,
            outAddre
        ) = abi.decode(
            exchangeData,
            (uint256, uint256, address[], address, uint256, address, address)
        );
        return
            swapInputV2(
                amountInArr,
                amountOutMinArr,
                pathArr,
                to,
                deadLines,
                inputAddre,
                outAddre
            );
    }

    // v2
    function swapInputV2(
        uint256 _amountInArr,
        uint256 _amountOutMinArr,
        address[] memory _path,
        address _to,
        uint256 _deadLine,
        address _inputAddre,
        address _outAddre
    ) internal returns (uint256) {
        uint[] memory amounts;
        if (_inputAddre == address(0)) {
            amounts = IUniRouter01(swapRouter).swapExactETHForTokens{
                value: _amountInArr
            }(_amountOutMinArr, _path, _to, _deadLine);
        } else if (_outAddre == address(0)) {
            TransferHelper.safeApprove(_inputAddre, swapRouter, _amountInArr);
            amounts = IUniRouter01(address(swapRouter)).swapExactTokensForETH(
                _amountInArr,
                _amountOutMinArr,
                _path,
                _to,
                _deadLine
            );
        } else {
            TransferHelper.safeApprove(_inputAddre, swapRouter, _amountInArr);
            amounts = IUniRouter01(address(swapRouter)).swapExactTokensForTokens(
                _amountInArr,
                _amountOutMinArr,
                _path,
                _to,
                _deadLine
            );
        }
        return amounts.length > 0 ? amounts[amounts.length - 1] : 0;
    }

}
