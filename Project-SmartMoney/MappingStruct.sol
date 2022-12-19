// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract MappingStruct {

    struct Transaction {
        uint amount;
        uint timeStamp;
    }

    struct Balance {
        uint totalBalance;
        uint numberOfDeposits;
        mapping(uint => Transaction) deposits;
        uint numberOfWithdrawals;
        mapping(uint => Transaction) withdrawals;
    }

    mapping(address => Balance) public balances;

    function getDepositNumber(address _from, uint _numDeposit) public view returns(Transaction memory) {
        return balances[_from].deposits[_numDeposit];
    }
    function depositMoney() public payable {
        balances[msg.sender].totalBalance += msg.value;

        Transaction memory deposit = Transaction(msg.value, block.timestamp);
        balances[msg.sender].deposits[balances[msg.sender].numberOfDeposits] = deposit;
        balances[msg.sender].numberOfDeposits++;
    }

    function withdrawMoney(address payable _to, uint _amount) public {
        balances[msg.sender].totalBalance -= _amount;

        Transaction memory withdrawal = Transaction(_amount, block.timestamp);
        balances[msg.sender].withdrawals[balances[msg.sender].numberOfWithdrawals] = withdrawal;
        balances[msg.sender].numberOfWithdrawals++;

        _to.transfer(_amount);
    }

    // function getBalance() public view returns (uint) {
    //     return
    // }
}