// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract EventEmit {
    event Balance(address account, string message, uint amount);

    function addBalance(uint _amount) public {
        emit Balance(msg.sender, "has balance", _amount);
    }
}

contract ChatApp {
    event Chat(address _to, address _from, string _message);

    function sendMessage(address to, string memory message) public {
        emit Chat(to, msg.sender, message); 
    }
}

contract Event {

    event NewTrade(
        uint _date,
        address _from,
        address _to,
        uint _amount
    );

    function trade(address to, uint amount) external {
        emit NewTrade(block.timestamp, msg.sender, to, amount);
    }
}