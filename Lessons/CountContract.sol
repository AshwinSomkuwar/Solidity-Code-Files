// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

contract Counter {
    uint public count;

    mapping(address => uint) public balance;

    function increment() public {
        count += 1;
    }

    function decrement() public {
        count -= 1;
    }

    function updateBalance() public {
        balance[msg.sender] = 100;
    }
}