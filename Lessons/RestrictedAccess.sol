// SPDX-License-Identifier: MIT
pragma solidity = 0.8.17;

contract RestrictedAccess {
    address public owner = msg.sender;
    uint public creationTime = block.timestamp;

    modifier onlyBy(address account) {
        require(msg.sender == account, "Sender not authorized !!!");
        _;
    }

    modifier onlyAfter(uint _time) {
        require(block.timestamp >= _time, "Function called too early !!!");
        _;
    }

    modifier costs(uint amount) {
        require(msg.value >= amount, "Not enough ether provided");
        _;
    }

    function changeOwnerAddress(address newAddress) onlyBy(owner) public {
        owner = newAddress;
    }
    // function to disown the current owner
    function disown() onlyBy(owner) onlyAfter(creationTime + 3 seconds) public {
        delete owner;
    } 

    function forceOwnerChange(address _newAddress) costs(200 ether) public payable {
        owner = _newAddress;
    }
}

