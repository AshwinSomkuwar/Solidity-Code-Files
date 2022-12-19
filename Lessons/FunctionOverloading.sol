// SPDX-License-Identifier: MIT
pragma solidity = 0.8.17;

contract FunctionOverloading {

    // You can have multiple definations for the same function name in the same scope
    // The definition of the function must differ from each other by the types and/or 
    // the number of arguments in the argument list
    // You cannot overload function declaration that differ only by return types

    // function x(bool switchLight) public {

    // }

    // function x(uint age) public {

    // }

    function sum(uint a, uint b) public pure returns (uint) {
        return a + b;
    }

    function sum(uint a, uint b, uint c) public pure returns (uint) {
        return a + b + c;
    }

    function sum2() public pure returns (uint) {
        return sum(1, 1);
    }

    function sum3() public pure returns (uint) {
        return sum(1, 1, 1);
    }
}