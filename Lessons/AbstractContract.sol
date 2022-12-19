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

