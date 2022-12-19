// SPDX-License-Identifier: MIT
pragma solidity = 0.8.17;

contract Enumerations {

    enum FrenchFriesSizes { SMALL, MEDIUM, LARGE }
    FrenchFriesSizes choice;
    FrenchFriesSizes constant defaultChoice = FrenchFriesSizes.MEDIUM;

    function setSmallSize() public {
        choice = FrenchFriesSizes.SMALL;
    }

    function customerChoice() public view returns (FrenchFriesSizes) {
        return choice;
    }

    function getDefaultChoice() public pure returns (uint) {
        return uint(defaultChoice);
    }
}

contract EnumerationsShirt {

    enum ShirtColors { RED, WHITE, BLUE }
    ShirtColors choice;
    ShirtColors constant defaultChoice = ShirtColors.BLUE;

    function setWhite() public {
        choice = ShirtColors.WHITE;
    }

    function getChoice() public view returns (ShirtColors) {
        return choice;
    }

    function getDefaultChoice() public pure returns (ShirtColors) {
        return defaultChoice;
    }
}