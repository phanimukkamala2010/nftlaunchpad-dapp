// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./FullERC721.sol";

contract Test5 is ERC721Enumerable, ReentrancyGuard, Ownable {

    uint256 private _tokenId;
	mapping (uint256 => bytes32) private _tokenId2Ens;

    constructor() ERC721("Test5", "Test5") Ownable() {
        _tokenId = 0;
	}

    function stringToBytes32(string memory source) internal pure returns (bytes32 result) {
        assembly {
            result := mload(add(source, 32))
        }
    }

    function addEns(string memory ensVal) public {
        _tokenId2Ens[_tokenId++] = stringToBytes32(ensVal);
    }

    function tokenURI(uint256 tokenId) override public view returns (string memory) {

        string memory output = "";
        output = string(abi.encodePacked(output, '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 2000 2000">'));
		output = string(abi.encodePacked(output, '<style>.baseWhite { fill: white; font-family: serif; font-size: 10px; }'));
		output = string(abi.encodePacked(output, '.baseGreen { fill: springgreen; font-family: serif; font-size: 10px; }</style>'));
		output = string(abi.encodePacked(output, '<rect width="100%" height="100%" fill="white" />'));

        for(uint256 i = 0; i < 10; ++i)
        {
            output = string(abi.encodePacked(output, '<text x="'));
            output = string(abi.encodePacked(output, Strings.toString((i%8)*250)));
            output = string(abi.encodePacked(output, '" y="'));
            output = string(abi.encodePacked(output, Strings.toString(((i/100)+1)*20)));
            output = string(abi.encodePacked(output, '" class="BaseGreen">'));
            //output = string(abi.encodePacked(output, _tokenId2Ens[i]));
            output = string(abi.encodePacked(output, "srikumar.eth"));
            output = string(abi.encodePacked(output, '</text>'));
        }
        output = string(abi.encodePacked(output, '</svg>'));

        string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Player #', Strings.toString(tokenId), '", "description": "Test5", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
        output = string(abi.encodePacked('data:application/json;base64,', json));

        return output;
    }

    function mintPlayer(uint256 tokenId) public nonReentrant onlyOwner {
        require(tokenId > 0 && tokenId < 10000, "Token ID invalid");
        _safeMint(owner(), tokenId);
    }
}
