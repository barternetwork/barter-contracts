

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "./interface/IERC20.sol";
import "./libs/TransferHelper.sol";
import "./interface/IBalancerSwap/IVault.sol";




contract BalancerSwap{

    address public constant BAlANCER_SWAP = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    bool   public constant  NTERNAL_CONST = false;


    function filterBalancer(IVault.SwapKind kind,IVault.BatchSwapStep[] memory swaps,IVault.FundManagement memory funds, IAsset[] memory  assets, int256[]  memory limit,uint256 deadline) external payable {
 
          if(limit.length == 1){
                _swap(swaps[0].poolId,kind,assets[0],assets[1],swaps[0].amount,swaps[0].userData,funds.sender,
                      funds.recipient,limit[0],deadline);
            }else{
                _batchSwap(kind,swaps,funds,assets,limit,deadline);
            } 

    }

    function _swap(bytes32 poolId,IVault.SwapKind kind,IAsset assetIn,IAsset assetOut, uint256 amount,bytes memory userData,address sender, address payable recipient,int256 limit,uint256 deadline)internal{
            
            uint256  amountCalculated;
            if(address(assetIn) == address(0)){
                 amountCalculated = IVault(BAlANCER_SWAP).swap{value:amount}(IVault.SingleSwap(poolId,kind,assetIn,assetOut,amount,userData),
                                        IVault.FundManagement(sender,NTERNAL_CONST,recipient,NTERNAL_CONST),uint256(limit),deadline);
            }else{
                  IERC20(address(assetIn)).approve(BAlANCER_SWAP,amount);
                  amountCalculated = IVault(BAlANCER_SWAP).swap(IVault.SingleSwap(poolId,kind,assetIn,assetOut,amount,userData),
                                        IVault.FundManagement(sender,NTERNAL_CONST,recipient,NTERNAL_CONST),uint256(limit),deadline);
            }
        }



    function _batchSwap(IVault.SwapKind kind,IVault.BatchSwapStep[] memory swaps,IVault.FundManagement memory funds, IAsset[] memory  assets, int256[]  memory limit,uint256 deadline) internal {
            
            int256[] memory amountCalculated;
        
            if(address(assets[0]) == address(0)){
                 amountCalculated = IVault(BAlANCER_SWAP).batchSwap{value:swaps[0].amount}(kind,swaps,assets,funds,limit,deadline);
            }else{
                  IERC20(address(assets[0])).approve(BAlANCER_SWAP,swaps[0].amount);
                  amountCalculated = IVault(BAlANCER_SWAP).batchSwap(kind,swaps,assets,funds,limit,deadline);
            }
        
        }
}
