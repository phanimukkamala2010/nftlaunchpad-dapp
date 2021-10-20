// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./PlayerFCC.sol";

contract MatchFCC is PlayerFCC {

    mapping (address => bytes32) private _address2Players;
    uint256 private _blockNumber;

    constructor() {
        _blockNumber = block.number;
    }

    function getBlockNumber() external view returns (uint256) {
        return _blockNumber;
    }

    function addMatchPlayers(string memory val) external    {
        _address2Players[msg.sender] = stringToBytes32(val);
    }

    function getMatchPlayers() external view returns (string memory) {
        return string(abi.encodePacked(_address2Players[msg.sender]));
    }

    function getMatchPoints() external view returns (uint256) {
        return getMatchPoints(msg.sender);
    }

    function getMatchCost() external view returns (uint256) {
        return getMatchCost(msg.sender);
    }

    function getMatchPlayersArray(address val) public view returns (uint256[11] memory) {
        bytes32 playerStr = _address2Players[val];
        uint256[11] memory result;
        uint256 currentIndex = 0;
        uint256 currentPos = 0;
        for(uint256 i = 0; i < playerStr.length; ++i)
        {
            uint8 c = uint8(playerStr[i]);
            if (c >= 48 && c <= 57) {
                currentIndex = currentIndex * 10 + (c - 48);
            }        
            else if(c == 59) {
                result[currentPos] = currentIndex;
                break;
            }
            else if(c == 58) {
                result[currentPos++] = currentIndex;
                currentIndex = 0;
            }
        }
        return result;
    }

    function getMatchCost(address val) public view returns (uint256) {
        uint256[11] memory players = getMatchPlayersArray(val);
        uint256 totalCost = 0;
        for(uint256 i = 0; i < 11; ++i)
        {
            totalCost += super.getCost(players[i]);
        }
        return totalCost;
    }

    function getMatchPoints(address val) public view returns (uint256) {
        uint256[11] memory players = getMatchPlayersArray(val);
        uint256 totalScore = 0;
        for(uint256 i = 0; i < 11; ++i)
        {
            totalScore += super.getPoints(players[i]);
        }
        return totalScore;
    }
}

