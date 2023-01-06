// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/*
The Auction Smart Contract - Planning and Design
● Smart Contract for a Decentralized Auction like an eBay alternative
● The Auction has an owner (the person who sells a good or service), a start and an end
date;
● The owner can cancel the auction if there is an emergency or can finalize the auction
after its end time;
● People are sending ETH by calling a function called placeBid(). The sender’s address
and the value sent to the auction will be stored in mapping variable called bids;
● Users are incentivized to bid the maximum they are willing to pay, but they are not bound
to that full amount, but rather to the previous highest bid plus an increment. The
contract will automatically bid up to a given amount;
● The highestBindingBid is the selling price and the highestBidder the person who won
the auction;
● After the auction ends the owner gets the highestBindingBid and everybody else
withdraws their own amount; 
*/

contract Auction {

    // state variables:
    address payable public owner;

    // start of the auction
    uint public startBlock;

    // end of the auction
    uint public endBlock;
    string public ipfsHash;

    // to keep track of the auction's state, we made an enum
    // enum variables are implicitly converted to integers and starts from zero
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
        //endBlock = startBlock + 40320;
        endBlock = startBlock + 3;
        ipfsHash = "";
        //bidIncrement = 100; // 100 Wei
        bidIncrement = 1000000000000000000; 
        // highestBindingBid is One ether plus the previous highest bidder
    }

    // we don't want the owner to bid 
    // so we make a modifier 

    modifier notOwner() {
        require(msg.sender != owner, "You are the owner and you cannot the place a bid...");
        _;
    }

    // the auction will be placed between the startBlock and endBlock 
    // so we will make two modifiers 

    modifier afterStart() {
        require(block.number >= startBlock);
        _;
    }

    modifier beforeEnd() {
        require(block.number <= endBlock);
        _;
    }

    modifier onlyOwner() {
        require(owner == msg.sender, "You are not the Owner...");
        _;
    }

    // if something bad happened, the owner has the ability to cancel the auction 
    function cancelAuction() public onlyOwner {
        auctionState = State.Cancelled;
    }

    // creating a function which returns the minimum between the two values
    function min(uint a, uint b) pure internal returns (uint) {
        if (a <= b) {
            return a;
        } else {
            return b;
        }
    }

    // a function to place a bid
    // also we can add more than one modifier in a function
    function placeBid() public payable notOwner beforeEnd afterStart {
        require(auctionState == State.Running);
        require(msg.value >= 100, "Bid should be more than 100");

        // highestBindingBid is the sum of the lowest bid and bidIncrement
        // highestBindingBid = Selling Price

        // logic: 
        // if there are two bidders: 
        // bids[0x123...] = 40
        // bids[0xabc...] = 70
        // bidIncrement = 10
        // the highestBidder will be bids[0xabc...] with 70 bid amount
        // highestBindingBid will be 40 + 10 = 50

        // initially the bid value is zero of every participant
        // 0 is the default value of any key in the mapping
        // if it is the first time then msg.sender is 0
        uint currentBid = bids[msg.sender] + msg.value;

        // if the bidder [0x123...] wants to outbid the highestBidder, but he sends 15 wei
        // then bids[0x123...] = 40 + 15 = 55
        // highestBindingBid will be 55 + 10 = 65
        // it is still less than the highestBidder
        // therefore we have to add a condition that the current bid should always be
        // greater than the highestBindingBid

        require(currentBid > highestBindingBid);

        // update the bid of the participant with the current bid
        bids[msg.sender] = currentBid;

        // but in the previous case the highestBidder remains the same because 
        // the highestBindingBid is 65 but the highest bid is 70 which is greater than 65
        // so we have to add a condition and update the highestBindingBid

        if (currentBid <= bids[highestBidder]) {
            highestBindingBid = min(currentBid + bidIncrement, bids[highestBidder]);
        } else {
            highestBindingBid = min(currentBid, bids[highestBidder] + bidIncrement);
            highestBidder = payable(msg.sender);
        }
    }

    function finalizeAuction() public {
        require(auctionState == State.Cancelled || block.number > endBlock);
        require(msg.sender == owner || bids[msg.sender] > 0);

        address payable recipient;
        uint value;

        // if the auction was cancelled
        if (auctionState == State.Cancelled) {
            recipient = payable(msg.sender);
            value = bids[msg.sender];
        }
        // auction ended (not cancelled) 
         else {
             // this is the owner
             if (msg.sender == owner) {
                 recipient = owner;
                 value = highestBindingBid;
             } else {
                 // this is the highestBidder
                if (msg.sender == highestBidder) {
                    recipient = highestBidder;
                    value = bids[highestBidder] - highestBindingBid;
                } else {
                    // this is one of the bidder (neither highestBidder nor the owner)
                    recipient = payable(msg.sender);
                    value = bids[msg.sender];
                }
             }
        }

        // resetting the bids of the recipient to zero so that the recipient cannot 
        // reclaim the bidding amount by calling the finalizeAuction function
        bids[recipient] = 0;
        recipient.transfer(value);
    }
}