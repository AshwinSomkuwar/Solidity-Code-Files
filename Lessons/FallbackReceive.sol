// SPDX-License-Identifier: MIT
pragma solidity = 0.8.17;

contract FallbackReceive {

    event Log(string _function,address _sender, uint _value, bytes _data);

    fallback() external payable {
        emit Log("fallback...", (msg.sender), (msg.value), msg.data);

    }

    receive() external payable {
        emit Log("receive...", (msg.sender), (msg.value), "");

    }
 
    function getBalance() public view returns (uint) {
        // this means the address of the contract which is calling the function
        // this means current contract
        return address(this).balance;
    }
}

contract ReceiveAndFallback {
    uint public lastValueSent;
    string public lastFuncCalled;

    uint public myUint;

    function setMyUint(uint _newUint) public {
        myUint = _newUint;
    }

    // input 0xe492fd840000000000000000000000000000000000000000000000000000000000000064
    // because of this input, the EVM understands what it has to do
    // 0x - hexa digits
    // e492fd84 - function signature/identifier which is the name of the function and the value it expects
    // setMyUint(uint256)
    // web3.utils.sha3("setMyUint(uint256)") 
    // 0xe492fd842fb25dc4b3c624c80776108b452a545c682a78e4252b5560c6537b79


    // in order to receive Ether transfer, the contract should have either 'receive'
    // or payable 'fallback' function

    receive() external payable {

        // to update lastValueSent and lastFuncCalled
        lastValueSent = msg.value;
        lastFuncCalled = "receive";
    }

    fallback() external payable {
        lastValueSent = msg.value;
        lastFuncCalled = "fallback";
    }

    // if we are transacting ethers then it will be done by receive function by default
    // data is sent by fallback function 
    // if we don't have receive function then the ethers will be sent by fallback function

}

// by Andrei Dumitrescu
contract Deposit {
    // receive cannot have arguments, cannot return anything, must have external visibility and payable state mutability 
    receive() external payable {

    }

    fallback() external payable {

    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}