// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// 俩种角色：
//      受益人、资助人


contract CrowFunding {
    address public immutable beneficiary; // 受益人
    uint256 public immutable fundingGoal; // 筹资目标数量

    uint256 public fundingAmount; // 当前的金额
    mapping (address=>uint256) public funders;

    // 可迭代的映射
    mapping (address=>bool) public fundersInserted;
    address[] public fundersKey; // length

    //状态
    bool public AVAILABLED = true;

    // 部署的时候，写入受益人+筹资目标数量
    constructor(address beneficiary_,uint256 goal_){
        beneficiary = beneficiary_;
        fundingGoal = goal_;
    }

    // 资助
    // 可用的时候才可以捐
    function contribute() external payable {
        require(AVAILABLED,"CrowdFunding is closed");
        funders[msg.sender] += msg.value;
        fundingAmount += msg.value;
        // 1.检查
        if(!fundersInserted[msg.sender]){
            // 2.修改
            fundersInserted[msg.sender] = true;
            // 3.操作
            fundersKey.push(msg.sender);
        }
    }

    // 关闭
    function close() external returns(bool){
        // 1.检查
        if(fundingAmount < fundingGoal){
            return false;
        }
        uint256 amount = fundingAmount;

        // 2.修改
        fundingAmount = 0;
        AVAILABLED = false;

        // 3.操作
        payable(beneficiary).transfer(amount);
        return true;
    }

    // 捐款人数
    function fundersLength() public view returns(uint256){
        return fundersKey.length;
    }
}