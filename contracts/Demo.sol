
// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.17;


contract HelloComrades {

    // 当前进度的标记
    uint8 public  step = 0;

    address public  immutable leader;

    string internal constant UNKNOWN = unicode"我不知道如何处理它,你找有关部门吧";

    //用于修改step，只要合约step发生变化，都抛出此事间
    event Step(uint8);
    /*
     *  金额变动的日志
     *  只要合约的金额发生变化，都抛出此事件
     */
    event Log(string tag,address from,uint256 value,bytes data);

    // 只能领导才能调要
    modifier onlyLeader(){
        require(msg.sender == leader,unicode"必须领导才能说");
        _;
    }
    // 领导以外才能调用
    modifier notLeader(){
        require(msg.sender != leader,unicode"领导不能说");
        _;
    }

    /// 自定义错误

    /// 这是一个自定义错误，上方需要空一行
    error MyError(string msg);

    constructor (address leader_){
        require(leader_ != address(0),"invalid address");
        leader = leader_;
    }

    function hello(string calldata content) external onlyLeader returns(bool){
        if(step != 0){
            revert(UNKNOWN);
        }
        if(!review(content, unicode"同志们好")){
            revert MyError(unicode"必须说:同志们好");
        }
        step = 1;
        emit Step(step);
        return true;
    }

    function helloRes(string calldata content) external onlyLeader returns(bool){
        if(step != 1){
            revert(UNKNOWN);
        }
        if(!review(content, unicode"领导好")){
            revert MyError(unicode"必须说:领导好");
        }
        step = 2;
        emit Step(step);
        return true;
    }

    function comfort(string calldata content) external payable onlyLeader returns(bool){
        if(step != 2){
            revert(UNKNOWN);
        }
        if(!review(content, unicode"同志们辛苦了")){
            revert MyError(unicode"必须说:同志们辛苦了");
        }

        if(msg.value < 2 ether ){
            revert MyError(unicode"给钱！！最少给2个以太币！");
        }

        step = 3;
        emit Step(step);
        return true;
    }

    function comfortRes(string calldata content) external onlyLeader returns(bool){
        if(step != 3){
            revert(UNKNOWN);
        }
        if(!review(content, unicode"为人民服务")){
            revert MyError(unicode"必须说:为人民服务");
        }

        step = 4;
        emit Step(step);
        return true;
    }



    function destruct() external payable returns(bool){
        if(step != 4){
            revert(UNKNOWN);
        }

        emit Log("destruct", msg.sender, address(this).balance, msg.data);
        selfdestruct(payable (msg.sender));
        return true;
    }



    function review(string calldata content,bytes memory correctContent)
    private
    pure
    returns(bool){
        return keccak256(abi.encodePacked((content))) == keccak256(correctContent);
    }

    receive() external payable {
        emit Log("receive",msg.sender,msg.value,"");
     }

    fallback() external payable {
        emit Log("fallback",msg.sender,msg.value,msg.data);
    }


    function getBalance() external view returns(uint256){
        return address(this).balance;
    }
}
