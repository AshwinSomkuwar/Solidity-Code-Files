// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract Auction {

    // state variables:
    address payable public owner;

    // start of the auction
    uint public startBlock;

    // end of the auction
    uint public endBlock;
    string public ipfsHash;

    // to keep track of the auction's state, we made an enum
    enum State { Started, Running, Ended, Cancelled }
    State public auctionState;

    uint public highestBindingBid;
    address payable public highestBidder;

    // to store the value proposed by an address
    mapping(address => uint) public bids;
    uint bidIncrement;

    constructor() {

        // predefined conditions

        owner = payable(msg.sender);
        auctionState = State.Running;
        startBlock = block.number;

        // how many blocks can be mined in a week if it takes 15 seconds to mine a block
        // (60 seconds in a minute * 60 minutes in an hour * 24 hours in a day * 7 days in a week) /
        // 15 seconds for a block
        endBlock = startBlock + 40320;
        ipfsHash = "";
        bidIncrement = 100; // 100 Wei
    }
}