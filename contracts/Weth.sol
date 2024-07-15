// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// WETH合约
contract WETH{
    string public constant name = "Wrapped Ether";
    string public constant symbol = "WETH";
    uint8 public constant decimals = 18;

    //event
    event Approval(address indexed src,address indexed delegateAds,uint256 amount);
    event Transfer(address indexed src,address indexed toAds,uint256 amount);
    event Deposit(address indexed toAdS,uint256 amount);
    event Withdraw(address indexed src,uint256 amount);

    mapping(address => uint256) public balance0f;
    mapping(address => mapping(address => uint256)) public allowance;

    function deposit() public payable{
        balance0f[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    
    function withdraw(uint256 amount_) public payable{
        // 取钱逻辑
        require(balance0f[msg.sender] >= amount_,"error amount");
        balance0f[msg.sender] -= amount_; // 写状态变量
        payable(msg.sender).transfer(amount_); // 真正的操作
        emit Withdraw(msg.sender, amount_);
    }

    function totalSupple() public view returns(uint256){
        return address(this).balance;
    }

    function approve(address delegateAds_,uint256 amount_) public returns(bool){
        allowance[msg.sender][delegateAds_] = amount_;
        emit Approval(msg.sender, delegateAds_, amount_);
        return true;
    }

    function transfer(address toAds_,uint256 amount_) public returns(bool){
        return transferFrom(msg.sender,toAds_,amount_);
    }

    function transferFrom(address src,address toAds_,uint256 amount_) public returns(bool){
        require(balance0f[src] >= amount_, "error amount"); // 检测

        if(src != msg.sender){
            require(allowance[src][msg.sender] > amount_);
            allowance[src][msg.sender] -= amount_;
        }

        balance0f[src] -= amount_;
        balance0f[toAds_] += amount_;

        emit Transfer(src, toAds_, amount_);

        return true;
    }

    receive() external payable { 
        deposit();
    }

}