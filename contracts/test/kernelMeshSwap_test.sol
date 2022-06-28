
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;


import "../interface/ISwap.sol";
import "../interface/IERC20.sol";
import "../interface/IBarterswapV2Router01.sol";
import "../libs/TransferHelper.sol";
import "../libs/SafeMath.sol";


// in dai - out USDT

contract kernelMeshSwap {

    address public constant MESH_SWAP = 0x10f4A785F458Bc144e3706575924889954946639;
    uint256 public amountInArr = 1 ether;
    uint256 public amountOutMinArr = 0;
    bytes public pathArr =  "0x000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000020000000000000000000000008f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063000000000000000000000000c2132d05d31c914a87c6611c10748aeb04b58e8f";
    address public to =  msg.sender;
    uint256 public deadLine = block.timestamp + 999999;
    address public inputAddre = 0x8f3Cf7ad23Cd3CaDbD9735AFf958023239c6A063;
    address public outAddre = 0xc2132D05D31c914a87C6611C10748AEb04B58e8F;

    function filterSwap() external  payable{

            if(inputAddre == address(0)){
                    require(msg.value == amountInArr,"Price is wrong");  
                   swapInputV2(amountInArr,amountOutMinArr,pathArr,to,deadLine,inputAddre,outAddre);
            }else{
                    TransferHelper.safeTransferFrom(inputAddre,msg.sender,address(this),amountInArr);
                    swapInputV2(amountInArr,amountOutMinArr,pathArr,to,deadLine,inputAddre,outAddre);
            }                 
    }
 


     // v2 
    function  swapInputV2(uint256 _amountInArr,uint256 _amountOutMinArr,bytes memory _path,address _to,uint256 _deadLine,address _inputAddre ,address _outAddre) internal{
                    uint[] memory amounts;
                    address[] memory pathArrs  = abi.decode(_path,(address[]));
                    if(_inputAddre == address(0)){
                        amounts = IBarterswapV2Router01(MESH_SWAP).swapExactETHForTokens{value:_amountInArr}(_amountOutMinArr,pathArrs,_to,_deadLine);
                    }else if(_outAddre == address(0)){
                        IERC20(_inputAddre).approve(MESH_SWAP,_amountInArr);
                        amounts = IBarterswapV2Router01(address(MESH_SWAP)).swapExactTokensForETH(_amountInArr,_amountOutMinArr,pathArrs,_to,_deadLine);
                    }else{
                        IERC20(_inputAddre).approve(MESH_SWAP,_amountInArr);
                        amounts = IBarterswapV2Router01(address(MESH_SWAP)).swapExactTokensForTokens( _amountInArr, _amountOutMinArr,pathArrs,_to,_deadLine);
                }
            }


    
  
}