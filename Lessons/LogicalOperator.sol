// SPDX-License-Identifier: MIT
pragma solidity = 0.8.17;

contract LogicalOperator {
    uint a = 17;
    uint b = 32;
    function operation() public view  returns(uint) {
       if ((b > a) && (a != b)) {
           return a * b;
       } else {
           return (a * b) / b;
       }
    }
}