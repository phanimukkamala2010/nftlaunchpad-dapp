// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./FullERC721.sol";

contract MetaBox is ERC721Enumerable, ReentrancyGuard, Ownable {

    constructor() ERC721("MetaBox", "METABOX") Ownable() {
	}

    string[] private _colors = [
            "coral",
            "lightcoral",
            "lightgreen",
            "lightsteelblue",
            "linen",
            "navajowhite",
            "palegoldenrod",
            "turquoise",
            "beige",
            "cornflowerblue",
            "darksalmon",
            "deepskyblue",
            "honeydew",
            "hotpink",
            "ivory",
            "lightcyan",
            "lightyellow",
            "peachpuff",
            "palegreen",
            "bisque",
            "darkcyan",
            "darkseagreen",
            "darkturquoise",
            "mediumturquoise",
            "dodgerblue",
            "lightseagreen",
            "lightsalmon",
            "olive",
            "steelblue",
            "crimson",
            "aqua",
            "aquamarine",
            "orangered",
            "gold",
            "silver"
                    ];

	function generatePlayer(uint256 tokenId) internal {
		PlayerInfo storage player = _tokenId2Player[tokenId];   //by reference

		player.creationTime = block.timestamp;
        if(tokenId % 3 == 0) { //human-male
            player.gender = gender[0];
            player.species = species[0];
            player.ageRemaining = 512;
            player.politicalSkills = pluck(tokenId, "POLITICS") % 11;
            player.technicalSkills = pluck(tokenId, "TECHNOLOGY") % 11;
            player.teachingSkills = pluck(tokenId, "TEACHER") % 11;
            player.doctorSkills = pluck(tokenId, "DOCTOR") % 11;
            player.lawyerSkills = pluck(tokenId, "LAWYER") % 11;
            player.policeSkills = pluck(tokenId, "POLICE") % 11;
            player.salesSkills = pluck(tokenId, "SALES") % 11;
            player.weapons = weapons[pluck(tokenId, "WEAPON") % weapons.length];
        }
        else if(tokenId % 3 == 1) { //human-female
            player.gender = gender[1];
            player.species = species[0];
            player.ageRemaining = 512;
            player.maxOffsprings = pluck(tokenId, "OFFSPRING") % 6;
            player.technicalSkills = pluck(tokenId, "TECHNOLOGY") % 11;
            player.politicalSkills = pluck(tokenId, "POLITICS") % 11;
            player.teachingSkills = pluck(tokenId, "TEACHER") % 11;
            player.doctorSkills = pluck(tokenId, "DOCTOR") % 11;
            player.lawyerSkills = pluck(tokenId, "LAWYER") % 11;
            player.policeSkills = pluck(tokenId, "POLICE") % 11;
            player.salesSkills = pluck(tokenId, "SALES") % 11;
        }
        else { //monster
		    player.gender = gender[tokenId % 2];
			player.species = species[1];
            player.ageRemaining = 128;
            player.maxOffsprings = pluck(tokenId, "OFFSPRING") % 6;
            player.legs = pluck(tokenId, "LEGS") % 11;
            player.wings = pluck(tokenId, "WINGS") % 2;
            player.claws = pluck(tokenId, "CLAWS") % 2;
		}
	}

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function pluck(uint256 tokenId, string memory keyPrefix) internal pure returns (uint256) {
        return random(string(abi.encodePacked(keyPrefix, Strings.toString(tokenId))));
    }

    function pluckShirt(uint256 tokenId, string memory keyPrefix) internal pure returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("SHIRT", Strings.toString(tokenId))));
        string memory str = "";
        if(rand%2 == 0) {
            str = string(abi.encodePacked(str, '<path d="M 170 300 l -40 -30 l -72 15 l -25 70 h 275 0 l -30 -70 l -72 -15 l -40 30 '));
            str = string(abi.encodePacked(str, '" style="fill: ', _colors(rand%35)));
            str = string(abi.encodePacked(str, '; stroke: grey; stroke-width: 0.5; stroke-linejoin: round; stroke-linecap: round" />'));
        }
        else {
            str = string(abi.encodePacked(str, '<path d="M 120 278 l -10 1 l 1 25 l 2 25 l -1 25 h 130 l -2 -25 l -2 -25 l -2 -25 l -10 -1 '));
            str = string(abi.encodePacked(str, 'v 25 a 52 52 0 0 1 -52 40 a 52 52 0 0 1 -52 -40 v -25 '));
            str = string(abi.encodePacked(str, '" style="fill: ', _colors(rand%35)));
            str = string(abi.encodePacked(str, '; stroke: none; stroke-width: 0.5"/>'));
        }
    }

    function pluckBody(uint256 tokenId, string memory keyPrefix) internal pure returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("BODY", Strings.toString(tokenId))));
        string memory str = "";
        str = string(abi.encodePacked(str, '<path d="M 140 225 l 1 4 l 2 6 l 0 8 l -2 10 l -2 8 l -4 10 l -4 4 l -8 1 l -8 1 '));
        str = string(abi.encodePacked(str, 'l -8 1 l -8 1 l -8 1 l -8 1 l -8 4 l -8 6 l -8 8 l -8 10 l -8 20 l -8 30 '));
        str = string(abi.encodePacked(str, 'l -8 40 h 285 l -8 -40 l -8 -30 l -8 -20 l -8 -10 l -8 -8 l -8 -6 l -8 -4 l -8 -1 '));
        str = string(abi.encodePacked(str, 'l -8 -1 l -8 -1 l -8 -1 l -8 -1 l -8 -1 l -4 -4 l -4 -10 l -2 -8 l -2 -10 l 0 -8 '));
        str = string(abi.encodePacked(str, 'l 2 -6 l 1 -4 h -60 " style="fill: ', _colors(rand%35));
        str = string(abi.encodePacked(str, '; stroke: grey; stroke-width: 0.5" />'));

        str = string(abi.encodePacked(str, '<path d="M 60 320 l -4 4 l -4 6 l -4 8 " style="fill: none; stroke: grey" />'));
        str = string(abi.encodePacked(str, '<path d="M 60 325 l -4 4 l -4 6 l -4 8 " style="fill: none; stroke: grey" />'));
        str = string(abi.encodePacked(str, '<path d="M 130 275 h 10 l 10 2" style="fill: none; stroke: grey" />'));
        str = string(abi.encodePacked(str, '<path d="M 130 277 h 12 l 10 2" style="fill: none; stroke: grey" />'));
        str = string(abi.encodePacked(str, '<path d="M 210 275 h -10 l -10 2" style="fill: none; stroke: grey" />'));
        str = string(abi.encodePacked(str, '<path d="M 210 277 h -12 l -10 2" style="fill: none; stroke: grey" />'));
        str = string(abi.encodePacked(str, '<path d="M 280 320 l 4 4 l 4 6 l 4 8 " style="fill: none; stroke: grey" />'));
        str = string(abi.encodePacked(str, '<path d="M 280 325 l 4 4 l 4 6 l 4 8 " style="fill: none; stroke: grey" />'));

        return str;
    }

    function tokenURI(uint256 tokenId) override public view returns (string memory) {


        string[64] memory parts;
		uint256 counter = 0;
        parts[counter++] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">';
		parts[counter++] = '<rect width="100%" height="100%" fill="black" />';
        parts[counter++] = pluckBody(tokenId);
        parts[counter++] = pluckShirt(tokenId);
        parts[counter++] = '</svg>';

        string memory output = "";
		for(uint256 i = 0; i < counter; ++i)
		{
			output = string(abi.encodePacked(output, parts[i]));
		}

        string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Box #', Strings.toString(tokenId), '", "description": "Boxed in Metaverse", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
        output = string(abi.encodePacked('data:application/json;base64,', json));

        return output;
    }

    function mintPlayer(uint256 tokenId) public nonReentrant onlyOwner {
        require(tokenId > 0 && tokenId < 129, "Token ID invalid");
        _safeMint(owner(), tokenId);
    }
}
