

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "../interface/IERC20.sol";
import "../libs/TransferHelper.sol";
import "../interface/IBalancerSwap/IVault.sol";
import "../interface/IBalancerSwap/IAsset.sol";



contract BalancerSwap_test{

    address public constant BAlANCER_SWAP = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    bool   public constant  NTERNAL_CONST = false;


    IVault.SwapKind kind;
    
    IVault.BatchSwapStep[]  swaps;

    uint256 deadline = block.timestamp + 99999;
    


    // testswap in MATIC - out USDT

    function filterBalancer_tets(IAsset[] memory assets,int256[] memory limit) external payable {
           
          IVault.BatchSwapStep memory _step_index1 = IVault.BatchSwapStep ({
                poolId:0x0297e37f1873d2dab4487aa67cd56b58e2f27875000100000000000000000002,
                assetInIndex:0,
                assetOutIndex:1,
                amount:500000000000000000,
                userData:"0x"

            });

            IVault.BatchSwapStep memory _steps_index2 = IVault.BatchSwapStep ({
                poolId:0x0297e37f1873d2dab4487aa67cd56b58e2f27875000100000000000000000002,
                assetInIndex:1,
                assetOutIndex:2,
                amount:0,
                userData:"0x"

            });
        
            IVault.FundManagement memory funds = IVault.FundManagement({
                sender:address(this),
                fromInternalBalance:false,
                recipient:payable(address(this)),
                toInternalBalance:false
            });
        
        swaps[0] = _step_index1;
        swaps[1] = _steps_index2;

          if(limit.length == 1){

                _swap(swaps[0].poolId,kind,assets[0],assets[1],swaps[0].amount,swaps[0].userData,funds.sender,
                      funds.recipient,limit[0],deadline);
            }else{
                _batchSwap(kind,swaps,funds,assets,limit,deadline);
            } 

    }


    function _swap(bytes32 poolIds,IVault.SwapKind kinds,IAsset assetIns,IAsset assetOuts, uint256 amounts,bytes memory userDatas,address senders, address payable recipients,int256 limits,uint256 deadlines)internal{
            
            uint256  amountCalculated;
            if(address(assetIns) == address(0)){
                require(msg.value == amounts,"Price is wrong");  
                 amountCalculated = IVault(BAlANCER_SWAP).swap{value:amounts}(IVault.SingleSwap(poolIds,kinds,assetIns,assetOuts,amounts,userDatas),
                                        IVault.FundManagement(senders,NTERNAL_CONST,recipients,NTERNAL_CONST),uint256(limits),deadlines);
            }else{
                  TransferHelper.safeTransferFrom(address (assetIns),msg.sender,address(this),amounts);
                  IERC20(address(assetIns)).approve(BAlANCER_SWAP,amounts);
                  amountCalculated = IVault(BAlANCER_SWAP).swap(IVault.SingleSwap(poolIds,kinds,assetIns,assetOuts,amounts,userDatas),
                                        IVault.FundManagement(senders,NTERNAL_CONST,recipients,NTERNAL_CONST),uint256(limits),deadlines);
            }
        }



    function _batchSwap(IVault.SwapKind kind,IVault.BatchSwapStep[] memory _batchSwap,IVault.FundManagement memory fundsDate,IAsset[] memory tokenaAddre, int256[]  memory limits,uint256 deadline) internal {
            
            int256[] memory amountCalculated; 
            
            if(address(tokenaAddre[0]) == address(0)){
                require(msg.value == swaps[0].amount,"Price is wrong");  
                 amountCalculated = IVault(BAlANCER_SWAP).batchSwap{value:swaps[0].amount}(kind,_batchSwap,tokenaAddre,fundsDate,limits,deadline);
            }else{
                  TransferHelper.safeTransferFrom(address(tokenaAddre[0]),msg.sender,address(this),swaps[0].amount);
                  IERC20(address(tokenaAddre[0])).approve(BAlANCER_SWAP,swaps[0].amount);
                  amountCalculated = IVault(BAlANCER_SWAP).batchSwap(kind,_batchSwap,tokenaAddre,fundsDate,limits,deadline);
            }
        
        }
}
