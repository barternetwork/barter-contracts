

// SPDX-License-Identifier: MIT

pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

import "./interface/IERC20.sol";
import "./interface/IBarterswapV2Router01.sol";
import "./interface/IV3SwapRouter.sol";
import "./interface/IWETH.sol.sol";
import "./libs/TransferHelper.sol";
import "./libs/SafeMath.sol";


contract BarterswapRouterV1 {
    using SafeMath for uint;
    address  payable public  feeTo; 
    address public feeToAdmin; 
    uint public fees; 

    address wethAddre = 0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270;
    address uniRouterArr = 0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45;

    struct swaps {
        address router;
        uint256 amountIn;
        uint256 amountOut;
    }
    
    struct DataAll{
       uint256[]  amountInArr;
       uint[]  amountOuntMinArr;
       bytes[]  pathArr;
       address[] routerArr;
       address to;
       uint256  deadline;
       address froms;
       address tos;
    }
    DataAll dataAll;
    event swap(address fromadddre ,address toaddre,address uses,swaps[] swapto);

    modifier onlyOwner() {
        require(msg.sender == feeToAdmin,'BarterswapV2Router: EXPIRED');
        _;
    }

     constructor(address _feeToAdmin) public {
        feeToAdmin = _feeToAdmin;
    }

     receive() external payable { 
    }


    function getAmountInArr(uint[] memory  amountInArr) public pure returns(uint){
        uint amountInArrs;
        for(uint i = 0; i < amountInArr.length; i++){
            amountInArrs += amountInArr[i];
        }
        return amountInArrs;
    }

   

    function multiSwap (uint256[] memory  amountInArr,uint256[] memory  amountOuntMinArr,
            bytes[] memory pathArr,address[] memory routerArr,address to,uint256 deadline,address froms,address tos) external payable {
        
        {
        uint amountInArrs = getAmountInArr(amountInArr);
        uint256 toFees = amountInArrs.mul(fees).div(1e18);
        if(froms == address(0)){
            require(msg.value == amountInArrs+toFees,"Price is wrong");
            TransferHelper.safeTransferETH(feeTo,toFees);
         }else{ 
            TransferHelper.safeTransferFrom(froms,msg.sender,address(this),amountInArrs );
            TransferHelper.safeTransferFrom(froms,msg.sender,feeTo,toFees); 
        }
       }

        dataAll = DataAll(amountInArr,amountOuntMinArr,pathArr,routerArr,to,deadline,froms,tos);
        swaps[] memory swapevent = new swaps[](dataAll.amountInArr.length);

        for(uint i = 0; i < dataAll.amountInArr.length; i++){
            if(dataAll.routerArr[i] == uniRouterArr){
                uint256 amountsv3;
                if(tos == address(0)){
                        amountsv3 = swapExactInputV3(dataAll.routerArr[i],dataAll.pathArr[i],address(this),dataAll.amountInArr[i],dataAll.amountOuntMinArr[i],dataAll.froms);
                        IWETH9(wethAddre).withdraw(amountsv3);
                        TransferHelper.safeTransferETH(dataAll.to,amountsv3);
                    }else{
                        amountsv3 = swapExactInputV3(dataAll.routerArr[i],dataAll.pathArr[i],dataAll.to,dataAll.amountInArr[i],dataAll.amountOuntMinArr[i],dataAll.froms);
                }
              swapevent[i] = swaps(dataAll.routerArr[i],dataAll.amountInArr[i],amountsv3);
            }else{
                uint[] memory amounts;
                address[] memory pathArrs  = abi.decode(dataAll.pathArr[i],(address[]));
                if(dataAll.froms == address(0)){
                    amounts = IBarterswapV2Router01(dataAll.routerArr[i]).swapExactETHForTokens{value:dataAll.amountInArr[i]}(dataAll.amountOuntMinArr[i],pathArrs,dataAll.to,dataAll.deadline);
                }else if(dataAll.tos == address(0)){
                    IERC20(dataAll.froms).approve(dataAll.routerArr[i],dataAll.amountInArr[i]);
                    amounts = IBarterswapV2Router01(address(dataAll.routerArr[i])).swapExactTokensForETH(dataAll.amountInArr[i],dataAll.amountOuntMinArr[i],pathArrs,dataAll.to,dataAll.deadline);
                }else{
                     IERC20(dataAll.froms).approve(dataAll.routerArr[i],dataAll.amountInArr[i]);
                     amounts = IBarterswapV2Router01(address(dataAll.routerArr[i])).swapExactTokensForTokens( dataAll.amountInArr[i], dataAll.amountOuntMinArr[i],pathArrs,dataAll.to,dataAll.deadline);
                }
                swapevent[i] = swaps(dataAll.routerArr[i],dataAll.amountInArr[i],amounts[amounts.length-1]);
            }       
        }
        emit swap(dataAll.froms,dataAll.tos,msg.sender,swapevent); 
    }
    


    function  swapExactInputV3(address _routers,bytes memory _path,address _recipient,uint256 amountIn,uint256 amountOuntMinArr,address froms) internal returns(uint amount){  
         if(froms == address(0)){
             amount = IV3SwapRouter(_routers).exactInput{value: amountIn}(IV3SwapRouter.ExactInputParams(_path, _recipient,amountIn, amountOuntMinArr));
         }else{
             IERC20(froms).approve(_routers,amountIn);
             amount = IV3SwapRouter(_routers).exactInput(IV3SwapRouter.ExactInputParams(_path, _recipient, amountIn, amountOuntMinArr));
        }
         
    }
        
                
    function setFeeTo(address payable _feeTo) public onlyOwner returns(bool) {
        require(_feeTo != address(0), 'Barterswap: FORBIDDEN');
        feeTo = _feeTo;
        return true;
    }

    function setFeeToSetter(address _feetoAdmin) public onlyOwner returns(bool) {
         require(_feetoAdmin != address(0), 'Barterswap: FORBIDDEN');
        feeToAdmin = _feetoAdmin;
        return true;
    }
    

     function setFees(uint _fees) public onlyOwner returns(bool) {
        require(_fees != 0, 'Barterswap: FORBIDDEN');
        fees = _fees;
        return true;
    }
    
 
    function getFactory(address _routerArr) public pure returns(address Factory){
        Factory = IVeniceswapV2Router01(_routerArr).factory(); 
    }
 
 
    function getWETH(address _routerArr) public pure returns(address WETH){
        WETH =  IVeniceswapV2Router01(_routerArr).WETH(); 
    }

}