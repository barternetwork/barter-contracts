
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

import "../interface/ISwap.sol";
import "../interface/IERC20.sol";
import "../libs/TransferHelper.sol";





interface ICurveFiCurve {

    function get_virtual_price() external returns (uint256 out);

    function add_liquidity(uint256[2] calldata amounts, uint256 deadline) external;

    function get_dy(int128 i, int128 j, uint256 dx)external view returns (uint256 out);

    function get_dy_underlying(int128 i,int128 j,uint256 dx)external view returns (uint256);

    function exchange(uint256 _amount,address[6] memory _route,uint256[8] memory _indices,uint256 _min_received,address _receiver) external payable;

    function get_exchange_routing(address _initial,address _target,uint256 _amount) external  view returns(address[6] memory,uint256[8] memory,uint256);

    function exchange_underlying(int128 i,int128 j,uint256 dx,uint256 min_dy) external returns(uint256);

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

}




contract CurveSwap_Test{
    
     address public constant CURVE_SWAP  = 0xfA9a30350048B2BF66865ee20363067c66f67e58;

    function filterCurve(uint256 _amount,address inputAddre,address[6] memory _route, uint256[8] memory _indices,uint256 _min_received,address _to) external  payable{
        
        if(inputAddre == address(0)){
            require(msg.value == _amount,"Price is wrong");
            ICurveFiCurve(CURVE_SWAP).exchange{value:_amount}(_amount,_route,_indices,_min_received,_to);
        }else{
            TransferHelper.safeTransferFrom(inputAddre,msg.sender,address(this),_amount);
            TransferHelper.safeApprove(inputAddre,CURVE_SWAP,_amount);
            ICurveFiCurve(CURVE_SWAP).exchange(_amount,_route,_indices,_min_received,_to);

            
        }
   
    }



    function get_exchange_routings(address _initial,address _target,uint256 _amount) external  view returns(address[6] memory,uint256[8] memory,uint256){
       address[6] memory _initials;
       uint256[8] memory _targets;
       uint256    _amounts;
        (_initials,_targets,_amounts) = ICurveFiCurve(CURVE_SWAP).get_exchange_routing(_initial,_target,_amount);
        return (_initials,_targets,_amounts);
         
    }

   
}

