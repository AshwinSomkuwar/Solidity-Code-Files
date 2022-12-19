// SPDX-License-Identifier: MIT
pragma solidity = 0.8.17;

// 1.
contract Member {
    string name;
    uint age;

    constructor(string memory _name, uint _age) public {
        name = _name;
        age = _age;
    }
}

contract Teacher is Member {
     constructor(string memory _n, uint _a) Member(_n, _a) public {

     }
         function getName() public view returns(string memory) {
         return name;
    }
}

// 2.
contract Base {
    uint data;

    constructor(uint _data) public {
        data = _data;
    }

    function getData() public view returns(uint) {
        return data;
    }
}

contract Derived is Base(5) {

    function getDerivedData() public view returns(uint) {
        return data;
    }
}

contract Constructor {
    address public myAddress;

    function showAddress() public view returns (address) {
        return myAddress;
    }

    function setMyAddress() public {
        myAddress = msg.sender;
    }
}