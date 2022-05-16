
// SPDX-License-Identifier: MIT
pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;

import "./ISwap.sol";
import "./interface/IERC20.sol";
import "./libs/TransferHelper.sol";





interface ICurveFiCurve {

    function get_virtual_price() external returns (uint256 out);

    function add_liquidity(uint256[2] calldata amounts, uint256 deadline) external;

    function get_dy(int128 i, int128 j, uint256 dx)external view returns (uint256 out);

    function get_dy_underlying(uint256 i, uint256 j, uint256 _dx)external view returns (uint256);

    function exchange(uint256 i,uint256 j,uint256 dx,uint256 min_dy) external;

    function exchange_underlying(uint256 i,uint256 j,uint256 _dx,uint256 _min_dy,address _receiver) external;

    function remove_liquidity(uint128 _amount,uint256 deadline,uint256[2] calldata min_amounts) external;

    function remove_liquidity_imbalance(uint256[2] calldata amounts, uint256 deadline)external;

    function commit_new_parameters(uint128 amplification,uint128 new_fee,uint128 new_admin_fee) external;

    function apply_new_parameters() external;

    function revert_new_parameters() external;

    function commit_transfer_ownership(address _owner) external;

    function apply_transfer_ownership() external;

    function revert_transfer_ownership() external;

    function withdraw_admin_fees() external;

    function coins(uint128 arg0) external returns (address out);

    function underlying_coins(uint128 arg0) external returns (address out);

    function balances(uint128 arg0) external returns (uint256 out);

    function A() external view returns (uint128 out);

    function fee() external returns (uint128 out);

    function admin_fee() external returns (uint128 out);

    function owner() external returns (address out);

    function admin_actions_deadline() external returns (uint256 out);

    function transfer_ownership_deadline() external returns (uint256 out);

    function future_A() external returns (uint128 out);

    function future_fee() external returns (uint128 out);

    function future_admin_fee() external returns (uint128 out);

    function future_owner() external returns (address out);
}

contract curveSwap{


    address public swapAddre = 0x1d8b86e3D88cDb2d34688e87E72F388Cb541B7C8;

    function filterCurve(address _to,address inputAddre,uint256[] memory _crvParams) external {
        // TransferHelper.safeTransferFrom(inputAddre,msg.sender,address(this),_crvParams[2]);
        IERC20(inputAddre).approve(swapAddre,_crvParams[2]);
        ICurveFiCurve(swapAddre).exchange_underlying(_crvParams[0],_crvParams[1],_crvParams[2],_crvParams[3],_to);
    }



    function get_dy_underlyings(uint256 i,uint256 j,uint256 _dx) public view returns(uint256){
        uint256  outs =  ICurveFiCurve(swapAddre).get_dy_underlying(i,j,_dx);
        return outs;
    }


    function  feestoadmins (address  payable _recipient, uint256 _amount,address _tokenaddress) public   returns(bool){
        if(_tokenaddress == address(0)){
           _recipient.transfer(_amount);
        }else{
            IERC20(_tokenaddress).transfer(_recipient,_amount);
        }
        return true;
    }
    

      function getcontractfees(address _tokenaddress) public view  returns(uint256){
        if(_tokenaddress == address(0)){
           return  address(this).balance;
        }else{
           return IERC20(_tokenaddress).balanceOf(address(this));
        }
    }

     receive() external payable {
        
    }

}



