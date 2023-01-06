// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/*
The CrowdFunding Contract - Planning and Design
● The Admin will start a campaign for CrowdFunding with a specific monetary goal and
deadline.
● Contributors will contribute to that project by sending ETH.
● The admin has to create a Spending Request to spend money for the campaign.
● Once the spending request was created, the Contributors can start voting for that
specific Spending Request.
● If more than 50% of the total contributors voted for that request, then the admin would
have the permission to spend the amount specified in the spending request.
● The power is moved from the campaign’s admin to those who donated the money.
● The contributors can request a refund if the monetary goal was not reached within the
deadline.
*/

contract CrowdFunding {

    // state variables

    mapping(address => uint) public contributors;
    address public admin;
    uint public numberOfContributors;
    uint public minimumContribution;
    uint public deadline; // timestamp

    // targeted money that we want to raise
    uint public goal;

    // at any point of time, we can check how much money we have raised
    uint public raisedAmount;

    // Spending Request
    struct Request {
        string description;
        address payable recipient;
        uint value;
        bool completed;
        uint numberOfVoters;
        mapping(address => bool) voters;
    }

    // mapping of spending requests
    // the key is the spending request number (index) - starts from zero
    // the value is a Request struct
    mapping(uint => Request) public requests;

    // this is necessary because a mapping does not use or increment 
    // indexes automatically like array
    uint public numberOfRequests;

    constructor(uint _goal, uint _deadline) {
        goal = _goal;
        deadline = block.timestamp + _deadline;
        minimumContribution = 100 wei;
        admin = msg.sender;
    }

    // Events to register the transaction outcome on the blockchain
    // It is not mandatory that the event has the same number of arguments as the function
    // that emits it
    event ContributionEvent(address _sender, uint _value);
    event RequestEvent(string _description, address _recipient, uint _value);
    event PaymentEvent(address _recipient, uint _value);

    // to contribute to the crowdfunding i.e. to send some ethers
    function contribute() public payable {
        require(block.timestamp < deadline, "Deadline has passed...");
        require(msg.value >= minimumContribution, "Your contribution should be greater than the minimum contribution...");

        // a condition to check if the contributor has sent ether for the first time
        if (contributors[msg.sender] == 0) {

            // even if a contributor has sent ethers more than once
            // we will record him only once
            // e.g. if person A gave 100 wei and person B gave 200 wei, the number of contributors 
            // will be 2 but if person A gave 200 wei again then the number of contributors 
            // will be 2 only 

            numberOfContributors++;
        }
        // updating the contributor's status
        contributors[msg.sender] += msg.value;

        // updating the raised amount
        raisedAmount += msg.value;

        emit ContributionEvent(msg.sender, msg.value);
    }

    // to send ethers directly to the contract's address so that the contract can receive
    receive() payable external {
        contribute();
    }

    // to return the balance of the contract
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    // if the money is not raised within the deadline, the contributors can request their money back
    function getRefund() public {

        // there are two condition that should be met 
        require(block.timestamp > deadline && raisedAmount < goal);

        // the contributors can call this function getRefund and only when they have 
        // given some ethers
        require(contributors[msg.sender] > 0);

        // the contributors who can get the refund
        address payable recipient = payable(msg.sender);

        // the amount of wei sent by the current contributor
        uint value = contributors[msg.sender];

        // transfering the amount to the recipient
        recipient.transfer(value);

        // the recipient and value variables are completely optional
        // we can achieve the same result by writing the code below
        // payable(msg.sender).transfer(contributors[msg.sender]);

        // to avoid the re-entrance attack, reset the value sent by 
        // this contributor BEFORE calling the transfer function
        contributors[msg.sender] = 0;
    }

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function...");
        _;
    }

    function createRequest(string memory _description, address payable _recipient, uint _value) public onlyAdmin {
        
        // numberOfRequest starts from zero
        Request storage newRequest = requests[numberOfRequests];
        numberOfRequests++;

        newRequest.description = _description;
        newRequest.recipient = _recipient;
        newRequest.value = _value;
        newRequest.completed = false;
        newRequest.numberOfVoters = 0;

        emit RequestEvent(_description, _recipient, _value);
    }

    function voteRequest(uint _requestNumber) public {
        
        // only contributors can vote
        require(contributors[msg.sender] > 0, "You must be a contributor to vote...");
        Request storage thisRequest = requests[_requestNumber];

        require(thisRequest.voters[msg.sender] == false, "You have already voted...");

        // this means that the user has already voted
        thisRequest.voters[msg.sender] = true;

        // incrementing the number of voters
        thisRequest.numberOfVoters++;
    }

    function makePayment(uint _requestNumber) public onlyAdmin {
        
        // only when the goal is achieved
        require(raisedAmount >= goal);

        Request storage thisRequest = requests[_requestNumber];
        require(thisRequest.completed == false, "The request has been completed...");

        // to check atleast 50% of the contributors have voted
        require(thisRequest.numberOfVoters > numberOfContributors / 2, "The requests needs more than 50% of the contributors...");

        // if the condition is met then transfer the value
        thisRequest.recipient.transfer(thisRequest.value);
        thisRequest.completed = true;

        emit PaymentEvent(thisRequest.recipient, thisRequest.value);
    }
}