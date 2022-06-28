
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;


import "./interface/ISwap.sol";
import "./interface/IERC20.sol";
import "./interface/IBarterswapV2Router01.sol";
import "./libs/TransferHelper.sol";
import "./libs/SafeMath.sol";



contract kernelMeshSwap {

    address public constant MESH_SWAP = 0x10f4A785F458Bc144e3706575924889954946639;
        
    function filterSwap(uint256  amountInArr,uint256  amountOutMinArr,bytes memory pathArr,address to,uint256 _deadLine, address inputAddre,address outAddre) external  payable{
            swapInputV2(amountInArr,amountOutMinArr,pathArr,to,_deadLine,inputAddre,outAddre);       
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