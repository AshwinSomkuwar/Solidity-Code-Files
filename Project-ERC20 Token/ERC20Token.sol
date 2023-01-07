// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// https://eips.ethereum.org/EIPS/eip-20

interface ERC20Interface {

    // There are six functions and two events in every token standards 
    function totalSupply() external view returns (uint256);
    function balanceOf(address _owner) external view returns (uint256 balance);
    function transfer(address _to, uint256 _value) external returns (bool success);

    function allowance(address _owner, address _spender) external view returns (uint256 remaining);
    function approve(address _spender, uint256 _value) external returns (bool success);
    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);

    // Events
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

/*
ERC20 Tokens - allowed, transferFrom() and approve()
● transfer() function is used to send tokens from one user to another, 
but it doesn’t work well when tokens are being used to pay for a function in a smart contract;
● ERC20 standard defines a mapping data structure named allowed and 2 functions 
approve(...) and transferFrom(...) that permit a token owner to give another address approval 
to transfer up to a number of tokens known as allowance;
● Allowances for an address can only be set by the token owner;
Imagine there are 2 users A and B. A has 1000 tokens and wants to give permission to B to spend 100 of them.
1. A will call approve(address_of_B, 100). After that the allowed data structure will contain the following information:
allowed[address_of_A][address_of_B] = 100
2. If B wants later to transfer 20 tokens from A to another account, B will execute
the transferFrom() function in this way: transferFrom(address_of_A, recipient_address, 20).
After calling the transferFrom() function (by B - msg.sender) the balance of A decreased by 20
and the balance of the recipient increased by 20 tokens and the allowed mapping will contain the following info:
allowed[address_of_A][address_of_B] = 80
*/

contract Cryptos is ERC20Interface {

    // state variables
    string public name = "Cryptos";
    string public symbol = "CRPT";
    uint public decimals = 0; // 18 digits
    uint public override totalSupply;

    address public founder;
    mapping(address => uint) public balances;

    // very important part
    mapping(address => mapping(address => uint)) allowed;

    // eg. 0x1111... (owner) wants to allow 100 tokens to be sent by 0x2222 (spender)
    // allowed[0x1111][0x2222] = 100;

    constructor() {
        totalSupply = 1000000;
        founder = msg.sender;
        balances[founder] = totalSupply;
    }

    function balanceOf(address tokenOwner) public view override returns (uint balance) {
        return balances[tokenOwner];
    }

    function transfer(address to, uint tokens) public override returns(bool success) {
        
        // to check that the sender has enough tokens to send
        require(balances[msg.sender] >= tokens, "You don't have enough tokens to send...");

        balances[to] += tokens;
        balances[msg.sender] -= tokens;

        // emitting the event to register a log
        emit Transfer(msg.sender, to, tokens);

        return true;
    }

        // this function gives allowance/permission to the spender to send the tokens 
    function allowance(address tokenOwner, address spender) public override view returns (uint256) {
        return allowed[tokenOwner][spender];
    }

    function approve(address spender, uint256 tokens) public override returns (bool success) {
        require(balances[msg.sender] >= tokens);
        require(tokens > 0);

        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);

        return true;
    }

    function transferFrom(address from, address to, uint256 tokens) public override returns (bool success) {
        require(allowed[from][msg.sender] >= tokens);
        require(balances[from] >= tokens);

        balances[from] -= tokens;
        allowed[from][msg.sender] -= tokens;
        balances[to] += tokens;

        emit Transfer(from, to, tokens);

        return true;
    }
}