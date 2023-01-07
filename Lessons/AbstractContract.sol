// SPDX-License-Identifier: MIT
pragma solidity = 0.8.17;

// base contract
abstract contract A {
    function getValue() public pure virtual returns (string memory) {
    }
}

// derived contract
contract B is A {
    function getValue() public override pure returns (string memory) {
        return "Say Hello";
    }
}

// base contract
contract Member {
    string name;
    uint age = 50;
    
    // function has no body so it is an abstract
    function getName() public virtual returns (string memory) {

    }

    function returnAge() public view returns (uint) {
        return age;
    }
}

// Abstract by Andrei
// abstract contracts cannot be deployed on the blockchain
// abstract contract can be used as a contract when other contracts are derived from it

abstract contract BaseContract {
    uint public x;
    address public owner;

    constructor() {
        x = 100;
        owner = msg.sender;
    }

    // if we remove the implementation of any function, the function should be 
    // marked as virtual and the contract should be marked as abstract
    
    // before:
    // function setX(uint _newX) public {
    //     x = _newX;
    // }

    // after:
    function setX(uint _newX) public virtual;
}

// if a contract is inherited from an abstract contract, it should implement the functions with
// override keyword, present in the base contract OR the inherited contract
// should also be marked as abstract

// NOTE: we cannot override the state variables

// before:
// contract DerivedContract is BaseContract {
//     uint public y = 300;
// }

// after:
// abstract contract DerivedContract is BaseContract {
//     uint public y = 300;
// }

// OR
contract DerivedContract is BaseContract {
    uint public y = 300;

    function setX(uint _newX) public override {

    }
}