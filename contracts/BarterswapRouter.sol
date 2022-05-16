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
        address    to;
        uint256    deadLine;
        address    inputAddre;
        address    outAddre;
        uint256[]    routerIndex;
        uint256[]  crvParams;
    } 


    function multiSwap (AccessParams calldata params) external payable {    
            uint256 amountInArrs = getAmountInAll(params.amountInArr,params.crvParams[2]);
            uint256 toFees = amountInArrs.mul(fees).div(1e18);

            if(params.inputAddre == address(0)){
                require(msg.value == amountInArrs+toFees,"Price is wrong");
                TransferHelper.safeTransferETH(feeTo,toFees);
            }else{ 
                TransferHelper.safeTransferFrom(params.inputAddre,msg.sender,address(this),amountInArrs );
                TransferHelper.safeTransferFrom(params.inputAddre,msg.sender,feeTo,toFees); 
            }

            for(uint i = 0; i < params.routerIndex.length; i++){
                address rindex = routerAddreAll[params.routerIndex[i]];
                // curve
                if (i == 0 && params.crvParams.length == 4){
                 crvSwap(params.inputAddre,rindex,params.to,params.crvParams[2],params.crvParams);
                }else{
                // uin
                    AmmSeriSwap(rindex,params.amountInArr[i],params.amountOutMinArr[i],params.pathArr[i],params.to,params.deadLine,params.inputAddre,params.outAddre);
                    }
                }
        }
    
    function crvSwap(address _inputAddre,address _rindex,address _to,uint256 _dx,uint256[] memory parameterList) internal{
        IERC20(_inputAddre).approve(_rindex,_dx);
        TransferHelper.safeTransfer(_inputAddre,_rindex,_dx);
        ISwap(_rindex).filterCurve(_to,_inputAddre,parameterList);
        
    }


    function AmmSeriSwap(address _rindex,uint256 _amountInArr,uint256 _amountOutMinArr,bytes memory _pathArr,address _to,uint256 _deadLine,address _inputAddre,address _outAddre) internal {
            if(_inputAddre == address(0)){
                    TransferHelper.safeTransferETH(_rindex,_amountInArr);
                    ISwap(_rindex).filterSwap(_amountInArr,_amountOutMinArr,_pathArr,_to,_deadLine,_inputAddre,_outAddre);      
                }else{
                    IERC20(_rindex).approve(_rindex,_amountInArr);
                    TransferHelper.safeTransfer(_inputAddre,_rindex,_amountInArr);
                    ISwap(_rindex).filterSwap(_amountInArr,_amountOutMinArr,_pathArr,_to,_deadLine,_inputAddre,_outAddre);     
                }
    }
    


    function getAmountInAll(uint256[] memory  amountInArr,uint256 OddNumber) public pure returns(uint256){
        uint amountInArrs;
        for(uint i = 0; i < amountInArr.length; i++){
            amountInArrs += amountInArr[i];
        }
        return amountInArrs + OddNumber;
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