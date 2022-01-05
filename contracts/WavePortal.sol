// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.4;

import "hardhat/console.sol";

contract WavePortal {
    uint256 totalWaves;
    uint8 waveId;
    uint256 private seed;

    event NewWave(
        uint8 id,
        address indexed from,
        uint256 timestamp,
        string message,
        uint8 totalLikes
    );

    event NewLike(
        uint8 waveId,
        bool liked,
        address indexed from,
        uint256 timestamp
    );

    struct Wave {
        uint8 id;
        address waver;
        string message;
        uint256 timestamp;
        uint8 totalLikes;
    }

    struct Like {
        uint8 waveId;
        bool liked;
        address waver;
        uint256 timestamp;
    }

    Wave[] waves;

    Like[] likes;

    mapping(address => uint256) public lastWavedAt;

    constructor() payable {
        console.log("We have been constructed!");

        seed = (block.timestamp + block.difficulty) % 100;
    }

    function wave(string memory _message) public {
        require(
            lastWavedAt[msg.sender] + 30 seconds < block.timestamp,
            "Must wait 30 seconds before waving again."
        );

        lastWavedAt[msg.sender] = block.timestamp;

        totalWaves += 1;
        console.log("%s has waved!", msg.sender);

        waves.push(Wave(waveId, msg.sender, _message, block.timestamp, 0));

        seed = (block.difficulty + block.timestamp + seed) % 100;

        if (seed <= 50) {
            console.log("%s won!", msg.sender);

            uint256 prizeAmount = 0.0001 ether;
            require(
                prizeAmount <= address(this).balance,
                "Trying to withdraw more money than they contract has."
            );
            (bool success, ) = (msg.sender).call{value: prizeAmount}("");
            require(success, "Failed to withdraw money from contract.");
        }

        emit NewWave(waveId, msg.sender, block.timestamp, _message, 0);

        waveId += 1;
    }

    function like(uint8 _waveId) public {
        console.log("%s has liked!", msg.sender);

        likes.push(Like(_waveId, true, msg.sender, block.timestamp));

        emit NewLike(_waveId, true, msg.sender, block.timestamp);

        waves[_waveId].totalLikes += 1;
    }

    function getAllWaves() public view returns (Wave[] memory) {
        return waves;
    }

    function getTotalWaves() public view returns (uint256) {
        return totalWaves;
    }

    function getWaveTotalLikes(uint8 _waveId) public view returns (uint8) {
        return waves[_waveId].totalLikes;
    }
}
