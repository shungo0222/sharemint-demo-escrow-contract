// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
  function transfer(address to, uint256 amount) external returns (bool);
  function balanceOf(address account) external view returns (uint256);
}

contract Escrow {
    address public owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event Withdrawal(address indexed tokenAddress, address indexed to, uint256 amount);

    constructor() {
      owner = msg.sender;
    }

    modifier onlyOwner() {
      require(msg.sender == owner, "You are not the owner");
      _;
    }

    function withdraw(address tokenAddress, address to, uint256 amount) external onlyOwner {
      IERC20 token = IERC20(tokenAddress);
      require(token.balanceOf(address(this)) >= amount, "Insufficient token balance");
      require(token.transfer(to, amount), "Transfer failed");
      emit Withdrawal(tokenAddress, to, amount);
    }

    function transferOwnership(address newOwner) external onlyOwner {
      require(newOwner != address(0), "Invalid address");
      emit OwnershipTransferred(owner, newOwner);
      owner = newOwner;
    }
}
