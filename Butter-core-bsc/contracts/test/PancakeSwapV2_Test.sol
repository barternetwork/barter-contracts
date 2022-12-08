

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;


import "../interface/ISwap.sol";
import "../interface/IERC20.sol";
import "../interface/IUniRouter01.sol";
import "../libs/TransferHelper.sol";
import "../libs/SafeMath.sol";



contract PancakeSwap_Test {

    address public constant PANCAKE_SWAP = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
        
     function filterSwap(bytes memory exchangeData) external  payable{
            uint256 amountInArr;
            uint256 amountOutMinArr;
            address[] memory pathArr;
            address to;
            uint256 deadLines;
            address inputAddre;
            address outAddre;

            (amountInArr,amountOutMinArr,pathArr,to,deadLines,inputAddre,outAddre) = abi.decode(
                exchangeData,
                (uint256,
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
                    if(_inputAddre == address(0)){
                          require(msg.value == _amountInArr,"Price is wrong");
                        amounts = IUniRouter01(PANCAKE_SWAP).swapExactETHForTokens{value:_amountInArr}(_amountOutMinArr,_path,_to,_deadLine);
                    }else if(_outAddre == address(0)){
                        TransferHelper.safeTransferFrom(_inputAddre,msg.sender,address(this),_amountInArr);
                        TransferHelper.safeApprove(_inputAddre,PANCAKE_SWAP,_amountInArr);
                        amounts = IUniRouter01(address(PANCAKE_SWAP)).swapExactTokensForETH(_amountInArr,_amountOutMinArr,_path,_to,_deadLine);
                    }else{
                        TransferHelper.safeTransferFrom(_inputAddre,msg.sender,address(this),_amountInArr);
                        TransferHelper.safeApprove(_inputAddre,PANCAKE_SWAP,_amountInArr);
                        amounts = IUniRouter01(address(PANCAKE_SWAP)).swapExactTokensForTokens( _amountInArr, _amountOutMinArr,_path,_to,_deadLine);
                }
            }

}