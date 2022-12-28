// SPDX-License-Identifier: MIT

pragma solidity ^ 0.8.17;

contract IfElse {
    uint oranges = 5;
    function validateOranges() public view returns(bool) {
        if (oranges == 5) {
            return true;
        }
        return false;
    }

    uint stakingWallet = 4;
     function airDrop() public view returns(uint) {
         if (stakingWallet == 10) {
             return stakingWallet + 10;
         } else {
             return stakingWallet + 1;
         }
     }
}