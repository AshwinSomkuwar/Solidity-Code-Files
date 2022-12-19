// SPDX-License-Identifier: MIT
pragma solidity = 0.8.17;

contract PayableContract {
    // we cannot make the visiblility of the function to view or pure
    // because we are adding ethers in that contract
    function payEthers() payable public {

    }
    // to check the balance... (this) means the contract, .balance is the 
    // method to get the balance 
    function checkBalance() public view returns (uint) {
        return address(this).balance;
    }

    // always add payable before the visibility of the variable
    // if you give payable after the visibility then you get an error
    // but in case of function, we can add payable even after the visibility
    address payable public owner = payable(msg.sender);

    // if we make a constructor, we can send some wei/ ethers even before the deployment of the contract
    constructor() payable {
        
    }
}