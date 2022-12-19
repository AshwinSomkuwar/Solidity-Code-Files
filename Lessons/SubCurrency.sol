// SPDX-License-Identifier: MIT
pragma solidity = 0.8.17;

contract Coin {
    address public minter;
    mapping(address => uint) public balances;
    event Send(address from, address to, uint amount);

    constructor() {
        minter = msg.sender;
    }

    function mintCoins(address receiver, uint amount) public {
        require(msg.sender == minter);
        balances[receiver] += amount;
    }

    error insufficientBalance(uint requested, uint available);

    function sendCoins(address receiver, uint amount) public {
        if (amount > balances[msg.sender])
            revert insufficientBalance({
                requested: amount,
                available: balances[msg.sender]
            });
        balances[msg.sender] -= amount;
        balances[receiver] += amount; 
        emit Send(msg.sender, receiver, amount);
    }
}