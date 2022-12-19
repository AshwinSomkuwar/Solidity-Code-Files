// SPDX-License-Identifier: MIT
pragma solidity = 0.8.17;

contract StringsIntro {
    string greetings = "Hello World !!!";

    function greet() public view returns(string memory) {
         return greetings;
    }

    function changeGreeting(string memory _change) public {
        greetings = _change;
    }

    function getChar() public view returns(uint) {
         bytes memory char = bytes(greetings);
         return char.length;
    }

    string favouriteColor = "blue";

    function returnColor() public view returns(string memory) {
        return favouriteColor;
    }

    function changeColor(string memory _colorName) public {
         favouriteColor = _colorName;
    }

    function charac() public view returns(uint) {
        bytes memory strToBytes = bytes(favouriteColor);
        return strToBytes.length;
    }
}

// comparing two strings

contract StringExample {
    string public greet1 = "Hello World";
    bytes public stringBytes = "Hello World";
    uint public length = stringBytes.length;
    function setGreetString(string memory _newString) public {
        greet1 = _newString;
    } 

    function compareStrings(string memory string2) public view returns (bool) {
        // two strings cannot be compared but we can compare the hash value of the strings
        return keccak256(abi.encodePacked(greet1)) == keccak256(abi.encodePacked(string2));
    }
}