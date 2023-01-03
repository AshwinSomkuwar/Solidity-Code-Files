// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Lottery {
    // array of players addresses which are payable
    address payable[] public players;
    // manager who controls and deploys the contracts
    address public manager;

    constructor() {
        manager = msg.sender;
    }
}