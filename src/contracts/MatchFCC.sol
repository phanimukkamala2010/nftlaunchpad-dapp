// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./PlayerFCC.sol";

contract MatchFCC is PlayerFCC {

    mapping (address => uint256[]) private _address2Players;
    
    function addMatchPlayers(uint256 index1, 
                             uint256 index2,
                             uint256 index3,
                             uint256 index4,
                             uint256 index5,
                             uint256 index6,
                             uint256 index7,
                             uint256 index8,
                             uint256 index9, 
                             uint256 index10,
                             uint256 index11) external {
        addMatchPlayer(index1);
        addMatchPlayer(index2);
        addMatchPlayer(index3);
        addMatchPlayer(index4);
        addMatchPlayer(index5);
        addMatchPlayer(index6);
        addMatchPlayer(index7);
        addMatchPlayer(index8);
        addMatchPlayer(index9);
        addMatchPlayer(index10);
        addMatchPlayer(index11);
    }

    function addMatchPlayer(uint256 index) private {
        _address2Players[msg.sender].push(index);
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

