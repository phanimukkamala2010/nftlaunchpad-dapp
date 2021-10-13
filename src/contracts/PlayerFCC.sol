// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./FCC.sol";

contract PlayerFCC {

    bytes32[] private _players = [
        stringToBytes32("ViratKohli"),
        stringToBytes32("MSDhoni"),
        stringToBytes32("HardikPandya"),
        stringToBytes32("GlennMaxwell"),
        stringToBytes32("ABD"),
        stringToBytes32("Padikkal"),
        stringToBytes32("Chahal"),
        stringToBytes32("SteveSmith")
    ];

    uint256[] private _costs = [
        20,
        10,
        15,
        12,
        7,
        13,
        14,
        15
    ];

    uint256[] private _points = [
        0,
        0
    ];

    constructor() {
    }

    function getPlayerIndex(string memory name) public view returns (uint256) {
        return getPlayerIndex(stringToBytes32(name));
    }

    function getPlayerIndex(bytes32 name) internal view returns (uint256) {
        uint256 count = _players.length;
        uint256 index = 999;
        for(uint256 i = 0; i < count; ++i)
        {
            if(name == _players[i]) {
                index = i;
                break;
            }
        }
        require(index != 999, "not a valid player");
        return index;
    }

    function getPlayerCount() external view returns (uint256)   {
        return _players.length;
    }

    function getPlayer(uint256 index) external view returns(string memory) {
        return string(abi.encodePacked(_players[index]));
    }
    
    function setPoints(uint256 playerIndex, uint256 val) external {
        _points[playerIndex] = val;
    }

    function getCost(uint256 playerIndex) public view returns (uint256) {
        return _costs[playerIndex];
    }

    function getPoints(uint256 playerIndex) internal view returns (uint256) {
        return _points[playerIndex];
    }

    function stringToBytes32(string memory source) internal pure returns (bytes32 result) {
        assembly {
            result := mload(add(source, 32))
        }
    }

    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }
}

