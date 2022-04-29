// SPDX-License-Identifier: MIT

pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

import "./interface/IERC20.sol";
import "./libs/TransferHelper.sol";
import "./libs/SafeMath.sol";
import "./ISwap.sol";





contract BarterswapRouterV1  {
    using SafeMath for uint;
    address  payable public  feeTo; 
    address public feeToAdmin; 
    uint public fees; 

   
    mapping(uint256 => address) public routerAddreAll;

    modifier onlyOwner() {
        require(msg.sender == feeToAdmin,'BarterswapV2Router: EXPIRED');
        _;
    }

     constructor(address _feeToAdmin) public {
        feeToAdmin = _feeToAdmin;
    }

     receive() external payable { 
    }


   struct AccessParams{
        uint256[]  amountInArr;
        uint256[]     amountOutMinArr;
        bytes[]    pathArr;
        // address[]  routerArr;
        address    to;
        uint256    deadLine;
        address    inputAddre;
        address    outAddre;
        uint256[]    routerIndex;
    } 



    function multiSwap (AccessParams calldata params) external payable {    
            uint256 amountInArrs = getAmountInAll(params.amountInArr);
            uint256 toFees = amountInArrs.mul(fees).div(1e18);
            if(params.inputAddre == address(0)){
                require(msg.value == amountInArrs+toFees,"Price is wrong");
                TransferHelper.safeTransferETH(feeTo,toFees);
            }else{ 
                TransferHelper.safeTransferFrom(params.inputAddre,msg.sender,address(this),amountInArrs );
                TransferHelper.safeTransferFrom(params.inputAddre,msg.sender,feeTo,toFees); 
            }

            for(uint i = 0; i < params.amountInArr.length; i++){
                address rindex = routerAddreAll[params.routerIndex[i]];
                if(params.inputAddre == address(0)){
                    TransferHelper.safeTransferETH(rindex,params.amountInArr[i]);
                    ISwap(rindex).filterSwap(params.amountInArr[i],params.amountOutMinArr[i],params.pathArr[i],params.to,params.deadLine,params.inputAddre,params.outAddre);      
                }else{
                    IERC20(params.inputAddre).approve(rindex,params.amountInArr[i]);
                    TransferHelper.safeTransfer(params.inputAddre,rindex,amountInArrs );
                    ISwap(rindex).filterSwap(params.amountInArr[i],params.amountOutMinArr[i],params.pathArr[i],params.to,params.deadLine,params.inputAddre,params.outAddre);     
                    }
            }
        }
    

    function getAmountInAll(uint[] memory  amountInArr) public pure returns(uint){
        uint amountInArrs;
        for(uint i = 0; i < amountInArr.length; i++){
            amountInArrs += amountInArr[i];
        }
        return amountInArrs;
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
    

    function setRouterAddreAll(uint256 index ,address _routeraddre) public onlyOwner returns(bool){
        require(_routeraddre != address(0),'Barterswap: FORBIDDEN');
        routerAddreAll[index] = _routeraddre;
        return true;
    }

  
}