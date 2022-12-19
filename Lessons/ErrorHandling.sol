// SPDX-License-Identifier: MIT
pragma solidity = 0.8.17;

contract ErrorHandling {
    bool public sunny = true;
    bool public umberella = false;
    uint finalCalculation = 0;

    // Solar Panel Machine
    function solarCalculator() public {
        require(sunny, "It is not sunny today");
        finalCalculation += 100;
        assert(finalCalculation != 200);
    } 
    // machine that controls the weather
    function weatherChanger() public {
        sunny = !sunny;
    }

    function getCalculation() public view returns (uint) {
        return finalCalculation;
    }

    // finalCalculation can never be 200
    function internalTestUnits() public view {
        assert(finalCalculation != 200);
    }
 
    function bringUmbrella() public {
        if (!sunny) {
            umberella = true;
        } else {
            revert("No need to bring an umberella today...");
        }
    }
}

contract Vendor {
    address public seller;
    modifier onlySeller() {
        require(msg.sender == seller, "Only seller can sell...");
        _;
    }

    function becomeSeller() public {
        seller = msg.sender;
    }

    function sell(uint amount) public payable onlySeller {
        if (amount > msg.value) {
            revert("There is not enough Ether provided...");
        }
    }
}