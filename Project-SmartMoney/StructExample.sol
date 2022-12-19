// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

// Approach 1. Using Child SmartContract

contract PaymentReceived {

    address public from;
    uint public amount;

    constructor(address _from, uint _amount) {
        from = _from;
        amount = _amount;
    }
}

contract Wallet {

    PaymentReceived public payment;

    function payContract() public payable {
        payment = new PaymentReceived(msg.sender, msg.value);
    }
}



// Approach 2. Using Structs
contract Wallet2 {

    struct PaymentReceivedStruct {
        address from;
        uint amount;
    }

    PaymentReceivedStruct public payment;

    function payContract() public payable {

        // format 1.
        //payment = PaymentReceivedStruct(msg.sender, msg.value);

        // format 2. we can also write in this format which is more readable
        payment.from = msg.sender;
        payment.amount = msg.value;
    }
}

// Advantages of using structs over child samrtContract are:
// 1. It reduces a lot of gas usage
// 2. It reduces the conplexities