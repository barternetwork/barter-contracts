
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;


import "./interface/ISwap.sol";
import "./interface/IERC20.sol";
import "./interface/IUniRouter02.sol";
import "./libs/TransferHelper.sol";
import "./libs/SafeMath.sol";



contract kernelSushiSwapV2 {

    address public constant SUSHI_SWAP = 0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F;
        
    function filterSwap(uint256  amountInArr,uint256  amountOutMinArr,bytes memory pathArr,address to,uint256 _deadLine, address inputAddre,address outAddre) external  payable{
            swapInputV2(amountInArr,amountOutMinArr,pathArr,to,_deadLine,inputAddre,outAddre);       
    }
 

     // v2 
    function  swapInputV2(uint256 _amountInArr,uint256 _amountOutMinArr,bytes memory _path,address _to,uint256 _deadLine,address _inputAddre ,address _outAddre) internal{
                    uint[] memory amounts;
                    address[] memory pathArrs  = abi.decode(_path,(address[]));
                    if(_inputAddre == address(0)){
                        amounts = IUniRouter02(SUSHI_SWAP).swapExactETHForTokens{value:_amountInArr}(_amountOutMinArr,pathArrs,_to,_deadLine);
                    }else if(_outAddre == address(0)){
                          TransferHelper.safeApprove(_inputAddre,SUSHI_SWAP,_amountInArr);
                        amounts = IUniRouter02(address(SUSHI_SWAP)).swapExactTokensForETH(_amountInArr,_amountOutMinArr,pathArrs,_to,_deadLine);
                    }else{
                        TransferHelper.safeApprove(_inputAddre,SUSHI_SWAP,_amountInArr);
                        amounts = IUniRouter02(address(SUSHI_SWAP)).swapExactTokensForTokens( _amountInArr, _amountOutMinArr,pathArrs,_to,_deadLine);
                }
            }

}