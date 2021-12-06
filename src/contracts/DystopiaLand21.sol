// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./FullERC721.sol";

contract DystopiaLand21 is ERC721Enumerable, ReentrancyGuard, Ownable {

    constructor() ERC721("DystopiaLand", "DYSTOPIALAND") Ownable() {
	}

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function pluck(uint256 tokenId, string memory keyPrefix) internal pure returns (uint256) {
        return random(string(abi.encodePacked(keyPrefix, Strings.toString(tokenId))));
    }

    function tokenURI(uint256 tokenId) override public pure returns (string memory) {

        string[64] memory parts;
		uint256 counter = 0;
        parts[counter++] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">';
		parts[counter++] = '<style>.baseWhite { fill: white; font-family: serif; font-size: 16px; }';
		parts[counter++] = '.baseGreen { fill: springgreen; font-family: serif; font-size: 16px; }</style>';
		parts[counter++] = '<rect width="100%" height="100%" fill="black" />';
        parts[counter++] = '<text x="10" y="40" class="baseWhite">';
        parts[counter++] = "LocationX:\t";
        parts[counter++] = Strings.toString(pluck(tokenId, "X-AXIS") % 1001);
        parts[counter++] = '</text><text x="10" y="60" class="baseWhite">';
        parts[counter++] = "LocationY:\t";
        parts[counter++] = Strings.toString(pluck(tokenId, "Y-AXIS") % 1001);
        parts[counter++] = '</text></svg>';

        string memory output = "";
		for(uint256 i = 0; i < counter; ++i)
		{
			output = string(abi.encodePacked(output, parts[i]));
		}

        string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Land #', Strings.toString(tokenId), '", "description": "Dystopia is a game of survival.", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
        output = string(abi.encodePacked('data:application/json;base64,', json));

        return output;
    }

    function mintLand(uint256 tokenId) public nonReentrant onlyOwner {
        require(tokenId > 0 && tokenId < 1001, "Token ID invalid");
        _safeMint(owner(), tokenId);
    }
}
