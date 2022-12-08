

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;


import "./interface/ISwap.sol";
import "./interface/IUniRouter01.sol";
import "./libs/TransferHelper.sol";
import "./libs/SafeMath.sol";



contract kernelUniSwapSwapV2 {


     address public constant UNISWAPV2 = 0x15e6C86A9AC9A32f91125794FDA82EEB807ed818;
        
     function filterSwap(bytes memory exchangeData) external  payable{
            uint256 amountInArr;
            uint256 amountOutMinArr;
            bytes memory pathArr;
            address to;
            uint256 deadLines;
            address inputAddre;
            address outAddre;

            (amountInArr,amountOutMinArr,pathArr,to,deadLines,inputAddre,outAddre) = abi.decode(
                exchangeData,
                (uint256,
                uint256,
                bytes,
                address,
                uint256,
                address,
                address));

            swapInputV2(amountInArr,amountOutMinArr,pathArr,to,deadLines,inputAddre,outAddre);              
    }
 

     // v2 
    function  swapInputV2(uint256 _amountInArr,uint256 _amountOutMinArr,bytes memory _path,address _to,uint256 _deadLine,address _inputAddre ,address _outAddre) internal{
                   
                    uint[] memory amounts;
                    address[] memory paths  = abi.decode(_path,(address[]));
                    if(_inputAddre == address(0)){
                        amounts = IUniRouter01(UNISWAPV2).swapExactETHForTokens{value:_amountInArr}(_amountOutMinArr,paths,_to,_deadLine);
                    }else if(_outAddre == address(0)){
                        TransferHelper.safeApprove(_inputAddre,UNISWAPV2,_amountInArr);
                        amounts = IUniRouter01(address(UNISWAPV2)).swapExactTokensForETH(_amountInArr,_amountOutMinArr,paths,_to,_deadLine);
                    }else{

                        TransferHelper.safeApprove(_inputAddre,UNISWAPV2,_amountInArr);
                        amounts = IUniRouter01(address(UNISWAPV2)).swapExactTokensForTokens( _amountInArr, _amountOutMinArr,paths,_to,_deadLine);
                }
            }

        receive() external payable { 
    }

}