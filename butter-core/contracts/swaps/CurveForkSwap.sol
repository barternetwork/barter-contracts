// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "../interface/ISwap.sol";
import "../interface/IERC20.sol";
import "../libs/TransferHelper.sol";
import "../interface/ICurveRouter.sol";

contract CurveForkSwap is ISwap {
     address public immutable swapRouter;

    constructor(address _swapRouter) {
       require(_swapRouter != address(0) && _swapRouter.code.length > 0);

        swapRouter = _swapRouter;
    }

    function filterSwap(
        bytes memory exchangeData
    ) external payable override returns (uint256) {
        address inputAddre;
        address[9] memory route;
        uint256[3][4] memory swap_params;
        uint256 amount;
        uint256 expected;
        address[4] memory pools;
        address receiver;
        (
            inputAddre,
            route,
            swap_params,
            amount,
            expected,
            pools,
            receiver
        ) = abi.decode(
            exchangeData,
            (
                address,
                address[9],
                uint256[3][4],
                uint256,
                uint256,
                address[4],
                address
            )
        );
        return
            exchange_Multiples(
                inputAddre,
                route,
                swap_params,
                amount,
                expected,
                pools,
                receiver
            );
    }

    function exchange_Multiples(
        address _inputAddre,
        address[9] memory _route,
        uint256[3][4] memory _swap_params,
        uint256 _amount,
        uint256 _expected,
        address[4] memory _pools,
        address _receiver
    ) internal returns (uint256) {
        if (_inputAddre == address(0)) {
            return
                ICurveRouter(swapRouter).exchange_multiple{value: _amount}(
                    _route,
                    _swap_params,
                    _amount,
                    _expected,
                    _pools,
                    _receiver
                );
        } else {
            TransferHelper.safeApprove(_inputAddre, swapRouter, _amount);
            return
                ICurveRouter(swapRouter).exchange_multiple(
                    _route,
                    _swap_params,
                    _amount,
                    _expected,
                    _pools,
                    _receiver
                );
        }
    }

}
