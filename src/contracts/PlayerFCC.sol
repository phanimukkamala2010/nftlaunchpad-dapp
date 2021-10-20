// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract PlayerFCC {

    bytes32[22] private _players = [
        /* 00 */ stringToBytes32("ViratKohli"),
        /* 01 */ stringToBytes32("MSDhoni"),
        /* 02 */ stringToBytes32("HardikPandya"),
        /* 03 */ stringToBytes32("GlennMaxwell"),
        /* 04 */ stringToBytes32("ABD"),
        /* 05 */ stringToBytes32("Padikkal"),
        /* 06 */ stringToBytes32("Chahal"),
        /* 07 */ stringToBytes32("Tripathi"),
        /* 08 */ stringToBytes32("ShubmanGill"),
        /* 09 */ stringToBytes32("PrithviShaw"),
        /* 10 */ stringToBytes32("Warner"),
        /* 11 */ stringToBytes32("RohitSharma"),
        /* 12 */ stringToBytes32("Pollard"),
        /* 13 */ stringToBytes32("Bravo"),
        /* 14 */ stringToBytes32("Hetmeyer"),
        /* 15 */ stringToBytes32("ShreyasIyer"),
        /* 16 */ stringToBytes32("Pant"),
        /* 17 */ stringToBytes32("Ishan"),
        /* 18 */ stringToBytes32("Suryakumar"),
        /* 19 */ stringToBytes32("ShardulThakur"),
        /* 20 */ stringToBytes32("DeepakChahar"),
        /* 21 */ stringToBytes32("SteveSmith")
    ];

    uint256[22] private _costs = [
        /* 00 */ 10,
        /* 01 */ 20,
        /* 02 */ 21,
        /* 03 */ 22,
        /* 04 */ 10,
        /* 05 */ 7,
        /* 06 */ 8,
        /* 07 */ 9,
        /* 08 */ 10,
        /* 09 */ 8,
        /* 10 */ 18,
        /* 11 */ 8,
        /* 12 */ 8,
        /* 13 */ 12,
        /* 14 */ 8,
        /* 15 */ 8,
        /* 16 */ 13,
        /* 17 */ 8,
        /* 18 */ 8,
        /* 19 */ 8,
        /* 20 */ 8,
        /* 21 */ 8
    ];

    uint256[22] private _points = [
        /* 00 */ 0,
        /* 01 */ 0,
        /* 02 */ 0,
        /* 03 */ 0,
        /* 04 */ 0,
        /* 05 */ 0,
        /* 06 */ 0,
        /* 07 */ 0,
        /* 08 */ 0,
        /* 09 */ 0,
        /* 10 */ 0,
        /* 11 */ 0,
        /* 12 */ 0,
        /* 13 */ 0,
        /* 14 */ 0,
        /* 15 */ 0,
        /* 16 */ 0,
        /* 17 */ 0,
        /* 18 */ 0,
        /* 19 */ 0,
        /* 20 */ 0,
        /* 21 */ 0
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

    function getPoints(uint256 playerIndex) public view returns (uint256) {
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

