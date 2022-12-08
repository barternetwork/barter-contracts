
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;


import "./interface/ISwap.sol";
import "./interface/IUniRouter01.sol";
import "./libs/TransferHelper.sol";
import "./libs/SafeMath.sol";


contract kernelSushiSwapV2 {

    address public constant SUSHI_SWAP = 0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F;
        
    function filterSwap(bytes memory exchangeData) external  payable{
            uint256 amountInArr;
            uint256 amountOutMinArr;
            address[] memory pathArr;
            address to;
            uint256 deadLines;
            address inputAddre;
            address outAddre;
            (amountInArr,amountOutMinArr,pathArr,to,deadLines,inputAddre,outAddre) = abi.decode(
                exchangeData,(
                uint256,
                uint256,
                address[],
                address,
                uint256,
                address,
                address));
            swapInputV2(amountInArr,amountOutMinArr,pathArr,to,deadLines,inputAddre,outAddre);       
    }
 

     // v2 
    function  swapInputV2(uint256 _amountInArr,uint256 _amountOutMinArr,address[] memory _path,address _to,uint256 _deadLine,address _inputAddre ,address _outAddre) internal{
                    uint[] memory amounts;
                    // address[] memory pathArrs  = abi.decode(_path,(address[]));
                    if(_inputAddre == address(0)){
                        amounts = IUniRouter01(SUSHI_SWAP).swapExactETHForTokens{value:_amountInArr}(_amountOutMinArr,_path,_to,_deadLine);
                    }else if(_outAddre == address(0)){
                          TransferHelper.safeApprove(_inputAddre,SUSHI_SWAP,_amountInArr);
                        amounts = IUniRouter01(address(SUSHI_SWAP)).swapExactTokensForETH(_amountInArr,_amountOutMinArr,_path,_to,_deadLine);
                    }else{
                        TransferHelper.safeApprove(_inputAddre,SUSHI_SWAP,_amountInArr);
                        amounts = IUniRouter01(address(SUSHI_SWAP)).swapExactTokensForTokens( _amountInArr, _amountOutMinArr,_path,_to,_deadLine);
                }
            }
            
        receive() external payable { 
    }
}