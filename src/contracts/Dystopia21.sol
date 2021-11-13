// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./FullERC721.sol";

contract Dystopia21 is ERC721Enumerable, ReentrancyGuard, Ownable {
    
	uint256 private creationTime;
	uint256 private politicalSkill;
	uint256 private shootingSkill;

	uint256 private ageRemaining;
	
	string[] private gender = [ "male", "female" ];

	string[] private species = [ "human", "dog", "monster" ];

	uint256[] private maxAge = [ 1024, 128, 256];

	string[] private weapons = [ "handgun", "shotgun", "monster-slayer" ];

    constructor() ERC721("Dystopia", "DYSTOPIA") Ownable() {
		creationTime = block.timestamp;
	}

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function getWeapon(uint256 tokenId) public view returns (string memory) {
        return pluck(tokenId, "WEAPON", weapons);
    }

    function pluck(uint256 tokenId, string memory keyPrefix, string[] memory sourceArray) internal view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked(keyPrefix, Strings.toString(tokenId))));
        string memory output = sourceArray[rand % sourceArray.length];
        output = string(abi.encodePacked("Weapon:", output));
        return output;
    }

    function tokenURI(uint256 tokenId) override public view returns (string memory) {
        string[32] memory parts;
		uint256 counter = 0;
        parts[counter++] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">';
		parts[counter++] = '<style>.baseWhite { fill: white; font-family: serif; font-size: 14px; }';
		parts[counter++] = '.baseGreen { fill: green; font-family: serif; font-size: 14px; }</style>';
		parts[counter++] = '<rect width="100%" height="100%" fill="black" />';
		parts[counter++] = '<text x="10" y="20" class="baseWhite">';
        parts[counter++] = getWeapon(tokenId);
        parts[counter++] = '</text><text x="10" y="40" class="baseGreen">';
        parts[counter++] = getWeapon(tokenId);
        parts[counter++] = '</text><text x="10" y="60" class="baseWhite">';
        parts[counter++] = getWeapon(tokenId);
        parts[counter++] = '</text><text x="10" y="80" class="baseWhite">';
        parts[counter++] = getWeapon(tokenId);
        parts[counter++] = '</text><text x="10" y="100" class="baseWhite">';
        parts[counter++] = getWeapon(tokenId);
        parts[counter++] = '</text><text x="10" y="120" class="baseWhite">';
        parts[counter++] = '</text></svg>';

        string memory output = "";
		for(uint256 i = 0; i < counter; ++i)
		{
			output = string(abi.encodePacked(output, parts[i]));
		}

        string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Bag #', Strings.toString(tokenId), '", "description": "Dystopia is a game.", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
        output = string(abi.encodePacked('data:application/json;base64,', json));

        return output;
    }

    function mintPlayer(uint256 tokenId) public nonReentrant onlyOwner {
        require(tokenId < 8001, "Token ID invalid");
        _safeMint(owner(), tokenId);
    }
}
