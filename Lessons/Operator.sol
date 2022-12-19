// SPDX-License-Identifier: MIT
pragma solidity > 0.7.0;

contract ComparisonOperator {
    uint a = 323;
    uint b = 54;

    function compare() public view {
        require(a <= b, "There is an ERROR !!!");
    }
}