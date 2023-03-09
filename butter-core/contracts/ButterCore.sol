// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "./interface/IERC20.sol";
import "./interface/IButterCore.sol";
import "./libs/TransferHelper.sol";
import "./libs/SafeMath.sol";
import "./interface/ISwap.sol";
import "./libs/Ownable2Step.sol";

contract ButterCore is IButterCore, Ownable2Step {
    using SafeMath for uint;


    mapping(uint256 => SwapConfig) public swapConfigs;

    mapping(uint256 => address) public swapTypeHandle; // 1 - univ2, 2 - univ3, 3 - curve


    constructor() { }

    function multiSwap(
        AccessParams calldata params
    ) external payable override returns (uint256) {
        uint256 amountInArrs = getAmountInAll(params.amountInArr);

        if (params.inputOutAddre[0] == address(0)) {
            require(msg.value == amountInArrs, "Price is wrong");
        } else {
            TransferHelper.safeTransferFrom(
                params.inputOutAddre[0],
                msg.sender,
                address(this),
                amountInArrs
            );
        }
        uint256 amountOut;
        for (uint i = 0; i < params.routerIndex.length; i++) {
            SwapConfig storage config = swapConfigs[params.routerIndex[i]];
            address handle = swapTypeHandle[config.swapType];
            require(
                config.swapRouter != address(0) && handle != address(0),
                "router or handle not set"
            );
            (bool success, bytes memory data) = handle.delegatecall(
                abi.encodeWithSelector(
                    ISwap.filterSwap.selector,
                    config.swapRouter,
                    params.paramsArr[i]
                )
            );
            require(success, "swap fail");
            uint256 _amountOutSingle = abi.decode(data, (uint256));
            amountOut += _amountOutSingle;
        }

        return amountOut;
    }

    function getAmountInAll(
        uint256[] memory amountInArr
    ) public pure returns (uint256) {
        uint256 amountInArrs;
        for (uint256 i = 0; i < amountInArr.length; i++) {
            amountInArrs += amountInArr[i];
        }
        return amountInArrs;
    }

    function setSwapTypeHandle(
        uint256 _swapType,
        address _handle
    ) external onlyOwner {
        require(_swapType > 0 && _handle.code.length > 0);
        swapTypeHandle[_swapType] = _handle;
    }

    function setSwapConfig(
        uint256 _index,
        SwapConfig calldata _config
    ) public onlyOwner returns (bool) {
        require(_config.swapRouter.code.length > 0, "router must be contract");
        require(_config.swapType > 0, "type must gt 0");
        swapConfigs[_index] = _config;
        return true;
    }

    receive() external payable {}
}
