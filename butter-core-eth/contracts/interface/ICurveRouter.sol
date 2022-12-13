
// // SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


interface ICurveRouter {

   function get_best_rate(address from,address to,uint256 amount) external view returns(address,uint256);

    function exchange_multiple(address[9] memory _route,uint256[3][4] memory _swap_params,uint256 _amount,uint256 _expected,address[4] memory _pools,address _receiver)payable external returns(uint256);
}
