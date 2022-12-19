// SPDX-License-Identifier: MIT

pragma solidity ^ 0.7.0;
 contract Functions {

     function multiplyCalculator(uint a, uint b) public view returns(uint) {
         uint result = a * b;
         return result;
     }
 uint public data = 10;
     function x() public view returns(uint) {
         return data + 15;
     }
     function y() public view returns(uint) {
         return data;
     }
 }