// SPDX-License-Identifier: MIT
pragma solidity = 0.8.17;

contract MultipleReturns {
    uint public changevalue;
    string public tom = "Hello !!!";

    function f() public pure returns (uint, bool, string memory) {
        return (100, true, "World");
    }

    function g() public {
        (changevalue, , tom) = f();
    }
}