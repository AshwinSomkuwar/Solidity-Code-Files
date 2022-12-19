// SPDX-License-Identifier: MIT
pragma solidity = 0.8.17;

contract Mapping {

    mapping(uint => Movie) movie;

    struct Movie {
        string title;
        string director;
    }

    function addMovie(uint _id, string memory _title, string memory _director) public {
        movie[_id] = Movie(_title, _director);

    }
}

contract NestedMapping {

    mapping(uint => Movie) movie;
    mapping(address => mapping(uint => Movie)) public myMovie;

    struct Movie {
        string title;
        string director;
    }

    function addMovie(uint _id, string memory _title, string memory _director) public {
        movie[_id] = Movie(_title, _director);
    }

    function addMyMovie(uint _id, string memory _title, string memory _director) public {
        myMovie[msg.sender][_id] = Movie(_title, _director);
    }
}
    
