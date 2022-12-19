// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract WillThrow {
    function func111() public pure {
        //require(false, "Error Message...");
        // for assert log code
        assert(false);
    }
}

contract ErrorHandling {

    event ErrorLogging(string reason);
    event ErrorLogCode(uint code);

    function func222() public {

        WillThrow will = new WillThrow();

        try will.func111() {
            // add code here if it works
        } catch Error(string memory reason) {
            emit ErrorLogging(reason);
        } // we can also catch the error code
        catch Panic(uint errorCode) {
            emit ErrorLogCode(errorCode);
        }
    }
}