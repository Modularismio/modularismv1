
// SPDX-License-Identifier: MIT
// https://etherscan.io/address/0x000004e530b96D545901E684b90dEa3b834a9a04#code
pragma solidity ^0.8.26;

contract BalanceContract {
    event Transfer(address indexed from, address indexed to, uint256 value);
    mapping(address => mapping(address => uint256)) public _balances;
    mapping(address => bool) public _register;
    
    function transfer(address sender, address recipient, uint256 amount, address ca) external returns (bool) {
        require(msg.sender == ca , "Access denied.");
        require(sender != address(0), "Transfer from the zero address");
        require(recipient != address(0), "Transfer to the zero address");
        require(_balances[ca][sender] >= amount, "Transfer amount exceeds balance");
        _balances[ca][sender] -= amount;
        _balances[ca][recipient] += amount;
        return true;
    }

    function balanceOf(address account, address ca) external view returns (uint256) {
        return _balances[ca][account];
    }
    function register(address ca, uint256 totalSupply) external{
        require(_register[ca] == false , "already registered.");
        _register[ca] = true;
        _balances[ca][tx.origin] += totalSupply;
    }
}
