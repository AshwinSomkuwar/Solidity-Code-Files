// SPDX-License-Identifier: MIT
pragma solidity = 0.8.17;

// like abstract contract we cannot deploy interfaces
// interfaces are like protocols

interface IHelloWorld {
    function getValue() external view returns (uint);
    function setValue(uint value) external; 
}

contract HelloWorld is IHelloWorld {
    uint private simpleInteger;
    function getValue() public view returns (uint) {
        return simpleInteger;
    }

    function setValue(uint _value) public {
        simpleInteger = _value;
    }
}

contract Client {
    function getSetIntegerValue() public returns (uint) {

        // making an object of HelloWorld
        IHelloWorld myObj = new HelloWorld();

        myObj.setValue(100);

        return myObj.getValue() + 10;

    }
}

// Advanced interfaces

interface IMath {
    function getSquare(uint value) external returns (uint);
}

contract Mathematics is IMath {
    function getSquare(uint value) external pure returns (uint) {
        return value * value;
    }
}

contract Client1 {
    function callSquare(address targetContract, uint inputValue) public returns (uint) {
        IMath targetMathematics = IMath(targetContract);
        return targetMathematics.getSquare(inputValue);
    }
}