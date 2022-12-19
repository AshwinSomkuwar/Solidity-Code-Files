// SPDX-License-Identifier: MIT
pragma solidity = 0.8.17;

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