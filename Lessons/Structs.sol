// SPDX-License-Identifier: MIT
pragma solidity = 0.8.17;

contract Structs {
    struct Movie {
        string director;
        string title;
        uint id;
    }

    Movie movie;

    function setMovie() public {
        movie = Movie("Rajamouli", "RRR", 100);
    }

    function getMovieId() public view returns (uint) {
        return movie.id;
    }
}