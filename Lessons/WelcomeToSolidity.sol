// SPDX-License-Identifier: MIT

pragma solidity >= 0.8.0 <0.9.0;

contract WelcomeToSolidity {

// constructor() public {

// }

    function getResult() public view returns(uint) {
        uint a = 5;
        uint b = 3;
        uint result = a * b;
        return result;
    }
}

contract LeaningVariables {
    uint wallet = 500;
    string notifySpend = "You have spent money"
    bool spend = false; 
}