// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract EnumContract {
    enum IceToppings {
        chocolate,
        cherry,
        almond
    }

    IceToppings public toppings;

    function get() public view returns (IceToppings) {
        return toppings;
    }

    function setToppings(IceToppings _toppings) public {
        toppings = _toppings;
    }
}