// SPDX-License-Identifier: MIT
pragma solidity = 0.8.17;

contract LoopsContract {
    function checkNum(uint _num1, uint _num2) public pure returns(bool) {
        if (_num1 % _num2 == 0) {
            return true;
        } else {
            return false;
        }
    }

    // uint [] public numberList = [1,2,3,4,5,6,7,8,9,10];
    // function multipleOf(uint _number) public view returns(uint) {
    //     uint count = 0;

    //     for (uint i = 0; i < numberList.length; i++) {
    //         if (multipleOf(numberList[i], _number)) {
    //             count++;
    //         }
    //     }
    //     return count;
    // }

    uint [] longList = [1,2,3,4,5,6,7,8,9,10];
    uint [] numberList1 = [1,45,23,67,98,34];

    function numberListLoop(uint _number1) public view returns(bool) {
        bool numberExists = false;

        for (uint i = 0; i < numberList1.length; i++) {
            
            if (numberList1[i] == _number1) {
                numberExists = true;
            }
        }
         return numberExists;
    }


    uint [] longList2 = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22];
    uint [] numberList2 = [1,45,23,67,98,34];

    function checkNumberisThere(uint _number2) public view returns(bool) {
        bool numExists = false;
        for (uint i = 0; i < numberList2.length; i++) {
            if (numberList2[i] == _number2) {
                numExists = true;
            }
        }
        return numExists;
    }

    function evenNumberFinder() public view returns(uint) {
        uint evenNumCounter = 0;

        for (uint i = 0; i < longList2.length; i++) {
            if (longList2[i] % 2 == 0) {
                evenNumCounter++;
            }
        }
        return evenNumCounter;
    }

}