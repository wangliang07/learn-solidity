// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// 存钱罐合约：多次存，一次取，取完就销毁
contract Bank {
    address public immutable onwner;

    event Deposit(address _ads,uint256 amount);
    event Withdraw(uint256 amount);

    receive() external payable { 
        deposit();
    }

    constructor(){
        onwner = msg.sender;
    }

    function withdraw() external {
        require(msg.sender == onwner,"Not owner address");
        emit Withdraw(address(this).balance);
    }

    function deposit() public payable {
        emit Deposit(msg.sender, msg.value);
    }

    function getBalance() external view returns(uint256){
        return address(this).balance;
    }
}