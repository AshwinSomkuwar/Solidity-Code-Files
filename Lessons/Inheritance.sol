// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract A {
    uint innerValue = 100;

    function innerAddTen(uint a) public pure returns (uint) {
        return a + 10;
    }
}

contract B is A {
    function outerAddTen(uint b) public pure returns (uint) {
         return A.innerAddTen(b);
    }

    function getInnerValue() public view returns(uint) {
        return A.innerValue;
    }
}

// Inheritance by Andrei
contract BaseContract {
    uint public x;
    address public owner;

    constructor() {
        x = 100;
        owner = msg.sender;
    }

    function setX(uint _newX) public {
        x = _newX;
    }
}

contract DerivedContract is BaseContract {
    uint public y;
}