// SPDX-License-Identifier: MIT
pragma solidity = 0.8.17;

contract LedgerBalance {
    mapping(address => uint) balance;
    function updatesBalance(uint _amount) public {
        balance[msg.sender] = _amount;
    }
}

contract Updated {

    function updateBalance() public {
        LedgerBalance ledgerBalance = new LedgerBalance();
        ledgerBalance.updatesBalance(30);
    }
}

contract SimpleStorage {
    uint storedData;

    function set(uint x) public {
        storedData = x;
        //storedData = block.difficulty;
        //storedData = block.timestamp;
         //storedData = block.number;
    }
// Pure and View

    function get() public view returns (uint) {
        //storedData = 50; // read only, cannot change value
        //return 30 + 30; // pure, can return value
    }
}