// SPDX-License-Identifier: MIT
pragma solidity = 0.8.17;

contract RandomNumberGenerator {

    // grab information from the blockchain randomly to generate random numbers - we need 
    // something dynamically changing
    // abi.encodePacked concatenates arguments
    
    function ranNumGen(uint range) external view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender))) % range;
    }
}