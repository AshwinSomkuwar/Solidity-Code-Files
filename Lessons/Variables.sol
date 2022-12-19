// SPDX-License-Identifier: MIT

pragma solidity 0.8.10;

contract Variables {
    string public greet = "Hello Janta..."; // state variables
    uint public num = 123;

    function demoFunction() public view returns (address) {
        //uint secondNumber = 200; // local variable
        return msg.sender; // global variable
    }


}