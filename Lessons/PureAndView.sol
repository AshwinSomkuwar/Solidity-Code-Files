// SPDX-License-Identifier: MIT
pragma solidity = 0.8.17;

contract PureAndViewExample {
    uint public value = 0;

    // here we are just reading the data from the state variable or blockchain, we are not modifying the data
    function viewData() public view returns (uint) {
        return value;
    }

    // here we are neither reading the data, nor modifying the data
    function pureData(uint x, uint y) public pure returns (uint) {
        return x + y;
    }


}

contract PureAndView {
    uint value;

    function setValue(uint newValue) public {
        value = newValue;
    }

    function getValue() public view returns (uint) {
        return value;
    }

    function multiply() public pure returns (uint) {
        return 3 * 7;
    }

    function valuePlusThree() public view returns (uint) {
        return value + 3; // here we are not changing the real value of 'value' 
        //eg. if the value was 30, we are just 3 to 30 but the value of 'value' remains 30
    }
}

contract ViewSample {
    function getBlockInfo() public view returns (uint) {
        uint blockNumber = block.number;
        return blockNumber;
    }
}