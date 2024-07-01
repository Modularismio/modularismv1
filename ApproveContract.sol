// SPDX-License-Identifier: MIT
// https://etherscan.io/address/0x000001bB5F23F6d5EaA1c6B1A2027D9849DC173f#code
pragma solidity ^0.8.26;

contract ApproveContract {
    event Approval(address indexed owner, address indexed spender, uint256 value);
    mapping(address => bool) public _register;
    mapping(address => mapping(address => mapping(address => uint256))) private _allowances;
    
    function approve(address owner, address spender, uint256 amount, address ca) external returns (bool) {
        require(msg.sender == ca , "Access denied.");
        _allowances[ca][owner][spender] = amount;
        
        return true;
    }

    function allowance(address owner, address spender, address ca) external view returns (uint256) {
        return _allowances[ca][owner][spender];
    }
}
