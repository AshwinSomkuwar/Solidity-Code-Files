// SPDX-License-Identifier: MIT
pragma solidity = 0.8.17;

contract A {
    uint innerVal = 100;

    function innerAddTen(uint a) public pure returns (uint) {
        return a + 10;
    }
}

contract B is A {
    function outerAddTen(uint b) public pure returns (uint) {
         return A.innerAddTen(b);
    }

    function getInnerVal() public view returns(uint) {
        return A.innerVal;
    }

}