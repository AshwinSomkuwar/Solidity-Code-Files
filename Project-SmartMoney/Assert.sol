// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract Assert {
    mapping(address => uint8) public balanceReceived;

    function receiveMoney() public payable {
        assert(msg.value == uint8(msg.value));
        balanceReceived[msg.sender] += uint8(msg.value);
    }

    function withdrawMoney(address payable _to, uint8 _amount) public {
        require(_amount <= balanceReceived[msg.sender], "Not enough fund...");
        balanceReceived[msg.sender] -= _amount;
        _to.transfer(_amount);
    }
} 