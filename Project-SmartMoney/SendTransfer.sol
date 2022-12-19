// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract Sender {
    receive() external payable {}

    function transfer(address payable _to) public {
        _to.transfer(10);
    }

    function send(address payable _to) public {
        _to.send(10);
    }
}

contract ReceiverNoAction {
    function balance() public view returns (uint) {
        return address(this).balance;
    }
    receive() external payable{}
}

contract ReceiverAction {
    uint public balanceReceived;

    receive() external payable {
        balanceReceived += msg.value;
    }

    function balance() public view returns (uint) {
        return address(this).balance;
    }
}