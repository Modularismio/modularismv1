// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;
// https://etherscan.io/address/0x46f551f9e77b105d58849dc2be446f4564a05a35#code
interface IApproveContract {
    function approve(address owner, address spender, uint256 amount, address ca) external returns (bool);
    function allowance(address owner, address spender, address ca) external view returns (uint256);
}

interface IBalanceContract {
    function transfer(address sender, address recipient, uint256 amount, address ca) external returns (bool);
    function balanceOf(address account, address ca) external view returns (uint256);
    function register(address ca, uint256 totalSupply) external;
}

contract MainContract {
    string public constant name = "Modularism";
    string public constant symbol = "Modularism";
    uint8 public constant decimals = 18;

    uint256 public totalSupply = 100000 * (10 ** uint256(decimals));

    IApproveContract private _approveContract;
    IBalanceContract private _balanceContract;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor(address approveAddress, address balanceAddress) {
        _approveContract = IApproveContract(approveAddress);
        _balanceContract = IBalanceContract(balanceAddress);
        _balanceContract.register(address(this), totalSupply);
        emit Transfer(address(0), msg.sender, totalSupply);

    }

    function transfer(address to, uint256 amount) public returns (bool) {
        emit Transfer(msg.sender, to, amount);
        bool success = _balanceContract.transfer(msg.sender, to, amount, address(this));
        require(success, "Transfer failed.");
        return success;
    }

    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        uint256 currentAllowance = _approveContract.allowance(from, msg.sender, address(this));
        require(currentAllowance >= amount, "Transfer amount exceeds allowance");
        bool success = _balanceContract.transfer(from, to, amount, address(this));
        require(success, "Transfer failed.");
        _approveContract.approve(from, msg.sender, currentAllowance - amount, address(this));
        emit Transfer(from, to, amount);
        return success;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balanceContract.balanceOf(account, address(this));
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        emit Approval(msg.sender, spender, amount);
        return _approveContract.approve(msg.sender, spender, amount, address(this));
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return _approveContract.allowance(owner, spender, address(this));
    }
}
