// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./PlayerFCC.sol";

contract MatchFCC is PlayerFCC {

    mapping (address => bytes32[]) private _address2Players;
    
    function addMatchPlayers(string memory name1, 
                             string memory name2,
                             string memory name3,
                             string memory name4,
                             string memory name5,
                             string memory name6,
                             string memory name7,
                             string memory name8,
                             string memory name9, 
                             string memory name10,
                             string memory name11) external {
        addMatchPlayer(stringToBytes32(name1));
        addMatchPlayer(stringToBytes32(name2));
        addMatchPlayer(stringToBytes32(name3));
        addMatchPlayer(stringToBytes32(name4));
        addMatchPlayer(stringToBytes32(name5));
        addMatchPlayer(stringToBytes32(name6));
        addMatchPlayer(stringToBytes32(name7));
        addMatchPlayer(stringToBytes32(name8));
        addMatchPlayer(stringToBytes32(name9));
        addMatchPlayer(stringToBytes32(name10));
        addMatchPlayer(stringToBytes32(name11));
    }

    function addMatchPlayer(bytes32 name) private {
        validPlayer(name);
        _address2Players[msg.sender].push(name);
    }

    function getMatchPoints() external view returns (uint256) {
        return getMatchPoints(msg.sender);
    }

    function getMatchCost(address val) public view returns (uint256) {
        uint256 totalCost = 0;
        for(uint256 i = 0; i < 11; ++i)
        {
            totalCost += super.getCost(_address2Players[val][i]);
        }
        return totalCost;
    }

    function getMatchPoints(address val) public view returns (uint256) {
        uint256 totalScore = 0;
        for(uint256 i = 0; i < 11; ++i)
        {
            totalScore += super.getPoints(_address2Players[val][i]);
        }
        return totalScore;
    }
}

