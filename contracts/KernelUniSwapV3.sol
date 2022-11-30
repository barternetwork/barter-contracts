
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;


import "./interface/ISwap.sol";
import "./interface/IERC20.sol";
import "./interface/IBarterswapV2Router01.sol";
import "./interface/IV3SwapRouter.sol";
import "./interface/IWETH9.sol";
import "./libs/TransferHelper.sol";
import "./libs/SafeMath.sol";


contract kernelUniSwapV3 {

    address public constant UNI_SWAP = 0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45;

    function filterSwap(uint256  amountInArr,uint256  amountOutMinArr,bytes memory pathArr,address to,address inputAddre,address outAddre) external  payable{
            swapInputV3(pathArr,to,amountInArr,amountOutMinArr,inputAddre,outAddre);       
    }
 


    // V3
    function  swapInputV3(bytes memory _path,address _recipient,uint256 _amountIn,uint256 _amountOutMinArr,address _inputAddre,address _outAddre) internal {
                uint256 amountsv3;
                 if(_outAddre == address(0)){
                        amountsv3 = swapExactInputV3(_path,address(this),_amountIn,_amountOutMinArr,_inputAddre);
                        IWETH9(getWeth(UNI_SWAP)).withdraw(amountsv3);
                        TransferHelper.safeTransferETH(_recipient,amountsv3);
                    }else{
                        amountsv3 = swapExactInputV3(_path,_recipient,_amountIn,_amountOutMinArr,_inputAddre);
                }
            }

    

    function  swapExactInputV3(bytes memory _path,address _recipient,uint256 _amountIn,uint256 _amountOutMinArr,address _inputAddre) internal returns(uint amount){  
         if(_inputAddre == address(0)){
             amount = IV3SwapRouter(UNI_SWAP).exactInput{value: _amountIn}(IV3SwapRouter.ExactInputParams(_path, _recipient,_amountIn, _amountOutMinArr));
         }else{
             TransferHelper.safeApprove(_inputAddre,UNI_SWAP,_amountIn);

             amount = IV3SwapRouter(UNI_SWAP).exactInput(IV3SwapRouter.ExactInputParams(_path, _recipient, _amountIn, _amountOutMinArr));
        }
         
    }

    function getWeth(address _routerArr) public pure returns(address WETH){
        WETH =  IBarterswapV2Router01(_routerArr).WETH(); 
    }

    receive() external payable { 
    }
}