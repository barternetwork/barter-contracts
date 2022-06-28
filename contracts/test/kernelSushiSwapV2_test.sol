
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;


import "../interface/ISwap.sol";
import "../interface/IERC20.sol";
import "../interface/IBarterswapV2Router01.sol";
import "../libs/TransferHelper.sol";
import "../libs/SafeMath.sol";



contract kernelSushiSwapV2_test {

    address public constant SUSHI_SWAP = 0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506;
        
    uint256  public _amountInArrs = 100000;
    uint256  public _amountOutMinArrs = 0;
    uint256 public _deadLines = block.timestamp + 999999;
    bytes  public  _pathArrs = "0x00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000002000000000000000000000000c2132d05d31c914a87c6611c10748aeb04b58e8f0000000000000000000000000d500b1d8e8ef31e21c99d1db9a6444d3adf1270";
    address public _inputAddres = 0xc2132D05D31c914a87C6611C10748AEb04B58e8F;
    address public _outAddres = 0x0000000000000000000000000000000000000000;
    address public _tos = msg.sender;



    function filterSwap() external  payable{
            swapInputV2(_amountInArrs,_amountOutMinArrs,_pathArrs,_tos,_deadLines,_inputAddres,_outAddres);       
    }
 

     // v2 
    function  swapInputV2(uint256 _amountInArr,uint256 _amountOutMinArr,bytes memory _path,address _to,uint256 _deadLine,address _inputAddre ,address _outAddre) internal{
                    uint[] memory amounts;
                    address[] memory pathArrs  = abi.decode(_path,(address[]));
                    if(_inputAddre == address(0)){
                        amounts = IBarterswapV2Router01(SUSHI_SWAP).swapExactETHForTokens{value:_amountInArr}(_amountOutMinArr,pathArrs,_to,_deadLine);
                    }else if(_outAddre == address(0)){
                        IERC20(_inputAddre).approve(SUSHI_SWAP,_amountInArr);
                        amounts = IBarterswapV2Router01(address(SUSHI_SWAP)).swapExactTokensForETH(_amountInArr,_amountOutMinArr,pathArrs,_to,_deadLine);
                    }else{
                        IERC20(_inputAddre).approve(SUSHI_SWAP,_amountInArr);
                        amounts = IBarterswapV2Router01(address(SUSHI_SWAP)).swapExactTokensForTokens( _amountInArr, _amountOutMinArr,pathArrs,_to,_deadLine);
                }
            }

}