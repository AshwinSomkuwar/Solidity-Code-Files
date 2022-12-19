// SPDX-License-Identifier: MIT
pragma solidity = 0.8.17;

contract EtherUnits {
    function test() public {
        assert(1000000000000000000 wei == 1 ether);
        assert(2^18 wei == 2 ether);
    }

    function exercise() public {
        assert(1 minutes == 60 seconds);
        assert(1 hours == 60 minutes);
        assert(1 days == 24 hours);
        assert(1 weeks == 7 days);
    }    
}