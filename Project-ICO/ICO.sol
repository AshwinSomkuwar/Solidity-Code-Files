// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/*
Planning the ICO
● Our ICO will be a Smart Contract that accepts ETH in exchange for our own token named
Cryptos (CRPT);
● The Cryptos token is a fully compliant ERC20 token and will be generated at the ICO time;
● Investors will send ETH to the ICO contract’s address and in return, they’ll get an amount of
Cryptos;
● There will be a deposit address (EOA account) that automatically receives the ETH sent to
the ICO contract;
● CRPT token price in wei is: 1CRPT = 0.001Eth = 10**15 wei, 1Eth = 1000 CRPT);
● The minimum investment is 0.01 ETH and the maximum investment is 5 ETH;
● The ICO Hardcap is 300 ETH;
● The ICO will have an admin that specifies when the ICO starts and ends;
● The ICO ends when the Hardcap or the end time is reached (whichever comes first);
● The CRPT token will be tradable only after a specific time set by the admin;

● In case of an emergency the admin could stop the ICO and could also change the deposit address
 in case it gets compromised;
● The ICO can be in one of the following states: beforeStart, running, afterEnd, halted;
● And we’ll also implement the possibility to burn the tokens that were not sold in the ICO;
● After an investment in the ICO the Invest event will be emitted;
*/

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

    // this function is called by the owner to transfer his tokens to another address
    // virtual means we can change this function's behaviour in the derived contract
    function transfer(address to, uint tokens) public virtual override returns(bool success) {
        
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

    // this function is called in behalf of the token owner, after the owner approved another address
    // to spend the tokens he possesses
    // virtual means we can change this function's behaviour in the derived contract
    function transferFrom(address from, address to, uint256 tokens) public virtual override returns (bool success) {
        require(allowed[from][msg.sender] >= tokens);
        require(balances[from] >= tokens);

        balances[from] -= tokens;
        allowed[from][msg.sender] -= tokens;
        balances[to] += tokens;

        emit Transfer(from, to, tokens);

        return true;
    }
}

// contract for ICO
contract CryptoICO is Cryptos {

    // state variables
    address public admin;

    // deposit is the address where all the ethers will be sent
    address payable public deposit;

    // 1 ETH = 1000 CRPT, 1 CRPT = 0.001 ETH
    uint public tokenPrice = 0.001 ether; 
    uint public hardCap = 300 ether;
    uint public raisedAmount;
    uint public saleStart = block.timestamp;

    // ICO ends in one week, 60 * 60 * 24 * 7
    uint public saleEnd = block.timestamp + 604800; 

    // tokens are only transferable/valid within a week after saleEnd
    uint public tokenTradeStart = saleEnd + 604800; 
    uint public maximumInvestment = 5 ether;
    uint public minimumInvestment = 0.1 ether;

    enum State { beforeStart, running, afterEnd, halted }
    State public icoState;

    constructor(address payable _deposit) {
        deposit = _deposit;
        admin = msg.sender;
        icoState = State.beforeStart;
    }

    // One very important requirement of this ICO is that the admin can stop the ICO 
    // in case of an emergency fro e.g. if the deposit address gets compromised or 
    // a security vulnerability is found

    modifier onlyAdmin() {
        require(msg.sender == admin, "You are not the admin...");
        _;
    }

    // function to halt the ICO in case of emergency
    function halt() public onlyAdmin {
        icoState = State.halted;
    }

    // to resume the ICO
    function resume() public onlyAdmin {
        icoState = State.running;
    }

    // function to change the address of deposit if it gets compromised
    function changeDepositAddress(address payable _newDepositAddress) public onlyAdmin {
        deposit = _newDepositAddress;
    }

    // function to get the current state of the ICO
    function getCurrentState() public view returns (State) {
        if (icoState == State.halted) {
            return State.halted;
        } else if (block.timestamp < saleStart) {
            return State.beforeStart;
        } else if (block.timestamp >= saleStart && block.timestamp <= saleEnd) {
            return State.running;
        } else {
            return State.afterEnd;
        }
    }

    event Invest(address investor, uint value, uint tokens);

    // function to invest 
    // this is the main function of the ICO and an Investor can send ethers by calling 
    // this function using a front-end app and sending ethers directly to the
    // contract's address by a wallet
    function invest() payable public returns (bool) {

        // getting the current state of the ICO by calling this function
       icoState = getCurrentState();
       require(icoState == State.running);

       require(msg.value >= minimumInvestment && msg.value <= maximumInvestment);

       // updating the raised amount
       raisedAmount += msg.value;

       // the raised amount should be less than or equal to the hardCap which is the maximum amount to be raised
       require(raisedAmount <= hardCap);

       uint tokens = msg.value / tokenPrice;

       // mapping made in ERC20 Token contract
       // in exchange of ethers the person should get the tokens
       balances[msg.sender] += tokens;
       balances[founder] -= tokens;

       // the amount sent, should be transferred in the deposit address
        deposit.transfer(msg.value);

        emit Invest(msg.sender, msg.value, tokens);

        return true;
    }

    // receive function will be automatically called when someone sends ethers directly to 
    // the contract's address
    receive() payable external {
        invest();
    }

    function transfer(address to, uint tokens) public override returns (bool success) {
        require(block.timestamp > tokenTradeStart);

        // we can also write this
        // super.transfer(to, tokens);
        Cryptos.transfer(to, tokens);

        return true;
    }

    function transferFrom(address from, address to, uint tokens) public override returns (bool success) {
        require(block.timestamp > tokenTradeStart);
        Cryptos.transferFrom(from, to, tokens);

        return true;
    }

    // function to burn the unsold tokens
    function burn() public returns (bool) {
        icoState = getCurrentState();
        require(icoState == State.afterEnd);
        balances[founder] = 0;

        return true;
    }
}