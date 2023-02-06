// SPDX-License-Identifier: MIT

pragma solidity 0.8.10;

contract Variables {
    // state variables
    string public greet = "Hello Janta..."; 
    uint public num = 123;

    function demoFunction() public view returns (address) {
        // local variable
        // uint secondNumber = 200; 

        // global variable
        return msg.sender; 
    }
}