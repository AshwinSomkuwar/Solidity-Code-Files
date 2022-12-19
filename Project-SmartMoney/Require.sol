// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract Require {
    mapping(address => uint) public balanceReceived;

    function receiveMoney() public payable {
        balanceReceived[msg.sender] += msg.value;
    }

    function withdrawMoney(address payable _to, uint _amount) public {
        require(_amount <= balanceReceived[msg.sender], "Not enough fund...");
        balanceReceived[msg.sender] -= _amount;
        _to.transfer(_amount);
    }
}

// transfering money from one address to another address

contract Require2 {

    mapping(address => uint) public balance;
    
    function receiveMoney(address to, uint amount) public payable {
        balance[to] += amount;
    }

    function sendMoney(address _to, address _from, uint _amount) public payable {
        require(_amount <= balance[_from], "Not enough fund...");
        balance[_from] -= _amount;
        balance[_to] += _amount;
    }

    function getBalance(address _ofAddress) public view returns (uint) {
        return balance[_ofAddress];
    }
}