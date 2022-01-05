// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "hardhat/console.sol";

contract SongPortal {
    uint256 totalLikes;

    event NewSong(address indexed from, bool liked, uint256 timestamp);

    struct Song {
        address waver;
        bool liked;
        uint256 timestamp;
    }

    Song[] songs;

    constructor() payable {
        console.log("We have been constructed!");
    }

    function like() public {
        totalLikes += 1;
        console.log("%s has waved!", msg.sender);

        songs.push(Song(msg.sender, true, block.timestamp));

        emit NewSong(msg.sender, true, block.timestamp);
    }

    function getTotalLikes() public view returns (uint256) {
        return totalLikes;
    }
}
