// SPDX-License-Identifier: MIT
pragma solidity = 0.8.17;

contract Arrays {
     uint[] public numbersArray;
     uint[200] public fixedArray;

     function add(uint _num) public {
         numbersArray.push(_num); 
     }

     function deleteNum() public {
         numbersArray.pop();
     }

     function getLength() public view returns (uint) {
         return numbersArray.length;
     }

     function removeNum(uint i) public {
         delete numbersArray[i];
     }
}

contract ExerciseArray {
    uint[] public changeArray;

    function removeElement(uint _i) public {
         changeArray[i] = changeArray[changeArray.length - 1];
         changeArray.pop();
    }

    function test() public {
         for(i = 1; i <= 4; i++) {
         changeArray.push(i);
        }
    }

    function deleteTheNum(uint _i) public {
         delete changeArray[i];
    }
}

