// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "../interface/ISwap.sol";
import "../interface/IUniRouter01.sol";
import "../interface/IV3SwapRouter.sol";
import "../interface/IWETH9.sol";

contract UniV3ForkSwap is ISwap {
    using SafeMath for uint;
    using SafeERC20 for IERC20;

    function filterSwap(
        address router,
        bytes memory exchangeData
    ) external payable override returns (uint256) {
        uint256 amountInArr;
        uint256 amountOutMinArr;
        bytes memory pathArr;
        address to;
        address inputAddre;
        address outAddre;
        (amountInArr, amountOutMinArr, pathArr, to, inputAddre, outAddre) = abi
            .decode(
                exchangeData,
                (uint256, uint256, bytes, address, address, address)
            );
        return
            swapInputV3(
                router,
                pathArr,
                to,
                amountInArr,
                amountOutMinArr,
                inputAddre,
                outAddre
            );
    }

    // V3
    function swapInputV3(
        address _router,
        bytes memory _path,
        address _recipient,
        uint256 _amountIn,
        uint256 _amountOutMinArr,
        address _inputAddre,
        address _outAddre
    ) internal returns (uint256) {
        uint256 amountsv3;
        if (_outAddre == address(0)) {
            amountsv3 = swapExactInputV3(
                _router,
                _path,
                address(this),
                _amountIn,
                _amountOutMinArr,
                _inputAddre
            );
            IWETH9(getWeth(_router)).withdraw(amountsv3);
            safeTransferETH(_recipient, amountsv3);
        } else {
            amountsv3 = swapExactInputV3(
                _router,
                _path,
                _recipient,
                _amountIn,
                _amountOutMinArr,
                _inputAddre
            );
        }
        return amountsv3;
    }

    function swapExactInputV3(
        address _router,
        bytes memory _path,
        address _recipient,
        uint256 _amountIn,
        uint256 _amountOutMinArr,
        address _inputAddre
    ) internal returns (uint amount) {
        if (_inputAddre == address(0)) {
            amount = IV3SwapRouter(_router).exactInput{value: _amountIn}(
                IV3SwapRouter.ExactInputParams(
                    _path,
                    _recipient,
                    _amountIn,
                    _amountOutMinArr
                )
            );
        } else {
            IERC20(_inputAddre).safeApprove(_router,_amountIn);
            amount = IV3SwapRouter(_router).exactInput(
                IV3SwapRouter.ExactInputParams(
                    _path,
                    _recipient,
                    _amountIn,
                    _amountOutMinArr
                )
            );
        }
    }

    function getWeth(address _routerArr) public pure returns (address WETH) {
        WETH = IV3SwapRouter(_routerArr).WETH9();
    }

    function safeTransferETH(address to, uint256 value) internal {
        (bool success, ) = to.call{value: value}(new bytes(0));
        require(success, 'ETH transfer failed');
    }
    receive() external payable {}
}
