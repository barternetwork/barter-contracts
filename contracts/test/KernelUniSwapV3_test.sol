
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;


import "../interface/ISwap.sol";
import "../interface/IERC20.sol";
import "../interface/IBarterswapV2Router01.sol";
import "../interface/IV3SwapRouter.sol";
import "../interface/IWETH9.sol";
import "../libs/TransferHelper.sol";
import "../libs/SafeMath.sol";



contract kernelUniSwapV3_test {

    address public constant Uni_SWAP = 0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45;

    uint256  public _amountInArrs = 100000;
    uint256  public _amountOutMinArrs = 0;
    bytes  public  _pathArrs = "0xc2132D05D31c914a87C6611C10748AEb04B58e8F000bb80d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270";
    address public _inputAddres = 0xc2132D05D31c914a87C6611C10748AEb04B58e8F;
    address public _outAddres = 0x0000000000000000000000000000000000000000;
    address public _tos = msg.sender;


    function filterSwap() external  payable{
            swapInputV3(_pathArrs,_tos,_amountInArrs,_amountOutMinArrs,_inputAddres,_outAddres);       
    }
 
    
    // V3
    function  swapInputV3(bytes memory _path,address _recipient,uint256 _amountIn,uint256 _amountOutMinArr,address _inputAddre,address _outAddre) internal {
                uint256 amountsv3;
                 if(_outAddre == address(0)){
                        amountsv3 = swapExactInputV3(_path,address(this),_amountIn,_amountOutMinArr,_inputAddre);
                        IWETH9(getWeth(Uni_SWAP)).withdraw(amountsv3);
                        TransferHelper.safeTransferETH(_recipient,amountsv3);
                    }else{
                        amountsv3 = swapExactInputV3(_path,_recipient,_amountIn,_amountOutMinArr,_inputAddre);
                }
            }

    

    function  swapExactInputV3(bytes memory _path,address _recipient,uint256 _amountIn,uint256 _amountOutMinArr,address _inputAddre) internal returns(uint amount){  
         if(_inputAddre == address(0)){
             amount = IV3SwapRouter(Uni_SWAP).exactInput{value: _amountIn}(IV3SwapRouter.ExactInputParams(_path, _recipient,_amountIn, _amountOutMinArr));
         }else{
             IERC20(_inputAddre).approve(Uni_SWAP,_amountIn);
             amount = IV3SwapRouter(Uni_SWAP).exactInput(IV3SwapRouter.ExactInputParams(_path, _recipient, _amountIn, _amountOutMinArr));
        }
         
    }

    function getWeth(address _routerArr) public pure returns(address WETH){
        WETH =  IBarterswapV2Router01(_routerArr).WETH(); 
    }

    receive() external payable { 
    }
}