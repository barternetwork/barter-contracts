// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "../interface/ISwap.sol";
import "../interface/IUniRouter01.sol";


contract UniV2ForkSwap is ISwap {
    using SafeMath for uint;
    using SafeERC20 for IERC20;

    function filterSwap(
        address  router,
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
                router,
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
        address _router,
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
            amounts = IUniRouter01(_router).swapExactETHForTokens{
                value: _amountInArr
            }(_amountOutMinArr, _path, _to, _deadLine);
        } else if (_outAddre == address(0)) {
            IERC20(_inputAddre).safeApprove(_router,_amountInArr);
            amounts = IUniRouter01(address(_router)).swapExactTokensForETH(
                _amountInArr,
                _amountOutMinArr,
                _path,
                _to,
                _deadLine
            );
        } else {
            IERC20(_inputAddre).safeApprove(_router,_amountInArr);
            amounts = IUniRouter01(address(_router)).swapExactTokensForTokens(
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
