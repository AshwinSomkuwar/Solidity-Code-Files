// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/*
The Lottery Smart Contract - Planning and Design
● The lottery starts by accepting ETH transactions. Anyone having an Ethereum wallet can
send a fixed amount of 0.1 ETH to the contract’s address.
● The players send ETH directly to the contract address and their Ethereum address is
registered. A user can send more transactions having more chances to win.
● There is a manager, the account that deploys and controls the contract.
● At some point, if there are at least 3 players, he can pick a random winner from the
players list. Only the manager is allowed to see the contract balance and to randomly
select the winner.
● The contract will transfer the entire balance to the winner’s address and the lottery is
  reset and ready for the next round.
*/

contract Lottery {

    // state variables
    // dynamic array of players addresses because we don't know
    // how many players will participate

    address payable[] public players;

    // manager who controls and deploys the contracts

    address public manager;

    constructor() {

        // initializing the owner of the address that deploys the contract

        manager = msg.sender;
    }

    // we can also use a modifier
    // modifier onlyOwner() {
    //     require(msg.sender == manager, "You are not the Manager...");
    //     _;
    // }

    receive() external payable {

        // declaring a receive() function which is necessary to receive the ether
        // adding a require condition to send only 0.1 ether to participate in the lottery

        require(msg.value == 0.1 ether, "The value should be exactly 0.1 Ethers...");

        // for pushing any contract's address in the players array, it has to be payable first

        players.push(payable(msg.sender));
    }

    // to get the balance of a current contract's address

    function getBalance() public view returns (uint) {

        // using require condition so that only the manager can call this function

        require(msg.sender == manager, "You are not the Manager...");

        return address(this).balance;
    }

    // to find the random number/value

    function random() public view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }

    // // to pick a winner and return the address of the winner
    // function pickAWinner() public view returns (address) {

    //     // only the manager can call this function
    //     require(msg.sender == manager, "You are not the Manager so you cannot call this function");

    //     // number of players can only be greater than or equal to 3
    //     require(players.length >= 3, "Players should be greater than or equal to 3...");

    //     // to get a random number
    //     uint randomNumber = random();

    //     // making a variable for the winner
    //     address payable winner;

    //     // to get a winner from the random number and players.length
    //     // using the modulo operator to find the winner 
    //     // example of modulo operator, 5 % 2 = 1, 19 % 5 = 4
    //     // example of winner, randomNumber = 100, players.length = 11, winnner will be 100 % 11 = 1
    //     // player at first index in the players array will be the winner 

    //     uint index = randomNumber % players.length;
    //     winner = players[index];

    //     return winner;

    // }

    // to pick a winner
    function pickAWinner() public {

        // only the manager can call this function

        require(msg.sender == manager, "You are not the Manager so you cannot call this function");

        // number of players can only be greater than or equal to 3

        require(players.length >= 3, "Players should be greater than or equal to 3...");

        // to get a random number

        uint randomNumber = random();

        // making a variable for the winner

        address payable winner;

        // to get a winner from the random number and players.length

        // using the modulo operator to find the winner 
        // example of modulo operator, 5 % 2 = 1, 19 % 5 = 4
        
        // example of winner, randomNumber = 100, players.length = 11, winnner will be 100 % 11 = 1
        // player at first index in the players array will be the winner 

        uint index = randomNumber % players.length;
        winner = players[index];

        // to transfer the ethers to the winner's address

        winner.transfer(getBalance());

        // after calling this function the random winner will be given the ethers that all the players gave 
        // to participate in the lottery

        // resetting the lottery to get ready for the next round by resetting the players array
        // (0) means size of the new dynamic array

        players = new address payable[](0);

        // after resetting the players array if we try to get the address at zero index, we get an error
        // because there is no address at zero index yet
    }
}