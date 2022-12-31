// SPDX-License-Identifier: MIT
pragma solidity = 0.8.17;

// modifiers are used to reuse the code
// eg.1 Basic
// eg.2 Inputs
// eg.3 Sandwich

contract ModifierFunction {
    bool public paused;
    uint public count;

    // eg.1 Basic

    // with modifier, we don't have to repeat the code, we can write the code in the modifier once 
    modifier onlyWhenPaused() {
        require(!paused, "Paused needs to be false...");
        _;
    }

    function setPause(bool _paused) external {
        paused = _paused;
    }

    // without modifier, 
    // we have to repeat the code wherever it is needed
    // function increment() external {
    //     require(!paused, "The condition is paused...");
    //     count++;
    // }

    // function decrement() external {
    //     require(!paused, "The condition is paused...");
    //     count--;
    // }

    // with modifier
        function increment() external onlyWhenPaused {
        count++;
    }

    function decrement() external onlyWhenPaused {
        count--;
    }

    // eg.2 Inputs
    // modifier with input value

    modifier withInput(uint _x) {
        require(_x < 100, "The value of x is more than 100...");
        _;
    }

    function incrementWithInput(uint _x) external onlyWhenPaused withInput(_x) {
        count += _x;
    }

    // eg.3 Sandwich
    // There is a code inside of a modifier which will be executed after the function 
    // is completed

    modifier sandwich() {
        count += 10;
        _;
        count * 2;
    } 

    function sandwichExample() external sandwich {
        count += 20;
    }
}