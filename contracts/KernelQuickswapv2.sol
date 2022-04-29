
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;


import "./ISwap.sol";
import "./interface/IERC20.sol";
import "./interface/IBarterswapV2Router01.sol";
import "./libs/TransferHelper.sol";
import "./libs/SafeMath.sol";



contract kernelQuickSwapV2 {

    address public constant QUICK_SWAP = 0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff;
        
    function filterSwap(uint256  amountInArr,uint256  amountOutMinArr,bytes memory pathArr,address to,uint256 _deadLine, address inputAddre,address outAddre) external  payable{
            swapInputV2(amountInArr,amountOutMinArr,pathArr,to,_deadLine,inputAddre,outAddre);       
    }
 

     // v2 
    function  swapInputV2(uint256 _amountInArr,uint256 _amountOutMinArr,bytes memory _path,address _to,uint256 _deadLine,address _inputAddre ,address _outAddre) internal{
                    uint[] memory amounts;
                    address[] memory pathArrs  = abi.decode(_path,(address[]));
                    if(_inputAddre == address(0)){
                        amounts = IBarterswapV2Router01(QUICK_SWAP).swapExactETHForTokens{value:_amountInArr}(_amountOutMinArr,pathArrs,_to,_deadLine);
                    }else if(_outAddre == address(0)){
                        IERC20(_inputAddre).approve(QUICK_SWAP,_amountInArr);
                        amounts = IBarterswapV2Router01(address(QUICK_SWAP)).swapExactTokensForETH(_amountInArr,_amountOutMinArr,pathArrs,_to,_deadLine);
                    }else{
                        IERC20(_inputAddre).approve(QUICK_SWAP,_amountInArr);
                        amounts = IBarterswapV2Router01(address(QUICK_SWAP)).swapExactTokensForTokens( _amountInArr, _amountOutMinArr,pathArrs,_to,_deadLine);
                }
            }

}