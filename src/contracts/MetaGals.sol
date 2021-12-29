// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./FullERC721.sol";

contract MetaGals is ERC721Enumerable, ReentrancyGuard, Ownable {

    constructor() ERC721("MetaGals", "METAGALS") Ownable() {
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

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function pluckClothes(uint256 tokenId) internal view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("CLOTHES", Strings.toString(tokenId))));
        string memory str = "";
        str = string(abi.encodePacked(str, '<path d="M 150,350 a 120 120 0 0 1 0 -50 a 120 120 0 0 1 30 30 a 120 120 0 0 1 30 -30 '));
        str = string(abi.encodePacked(str, 'a 120 120 0 0 1 0 50" '));
        str = string(abi.encodePacked(str, '" style="fill: ', _colors[rand%35], '; stroke: black; stroke-width: 0.3"/>'));
        str = string(abi.encodePacked(str, '<path d="M 165,180 a 30 60 0 0 1 15 0 l 2 0 a 30 60 0 0 1 15 0 a 20 20 0 0 1 -30 0" '));
        str = string(abi.encodePacked(str, '" style="fill: ', _colors[rand%35], '; stroke: black; stroke-width: 1"/>'));
        str = string(abi.encodePacked(str, '<path d="M 165,180 a 60 60 0 0 0 30 0"'));
        str = string(abi.encodePacked(str, '" style="fill: ', _colors[rand%35], '; stroke: black; stroke-width: 2"/>'));
        return str;
    }

    function pluckHair(uint256 tokenId) internal view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("HAIR", Strings.toString(tokenId))));
        string memory str = "";
        str = string(abi.encodePacked(str, '<path d="M 325,350 a 120 120 0 0 1 -10 -50 a 120 120 0 0 0 -10 -50 '));
        str = string(abi.encodePacked(str, 'a 120 120 0 0 1 -20 -100 a 120 120 0 0 0 -30 -100 a 120 120 0 0 0 -150 0 a 120 120 0 0 0 -30 100 '));
        str = string(abi.encodePacked(str, 'a 120 120 0 0 1 -20 100 a 120 120 0 0 0 -10 50 a 120 120 0 0 1 -10 50" '));
        str = string(abi.encodePacked(str, '" style="fill: ', _colors[rand%35], '; stroke: black; stroke-width: 0.3"/>'));
        return str;
    }

    function pluckBody(uint256 tokenId) internal view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("BODY", Strings.toString(tokenId))));
        string memory str = "";
        str = string(abi.encodePacked(str, '<path d="M 160,200 v 50 a 120 120 0 0 1 -30 10 a 180 180 0 0 0 0 100 '));
        str = string(abi.encodePacked(str, 'h 100 a 180 180 0 0 0 0 -100 a 120 120 0 0 0 -30 -10 v -50" '));
        str = string(abi.encodePacked(str, '" style="fill: ', _colors[rand%35], '; stroke: none; stroke-width: 0.2"/>'));

        str = string(abi.encodePacked(str, '<path d="M 100,130 a 120 120 0 0 0 20 60 a 120 120 0 0 0 60 30 a 120 120 0 0 0 60 -30 '));
        str = string(abi.encodePacked(str, 'a 120 120 0 0 0 20 -60 a 120 120 0 0 0 -10 -40 a 50 50 0 0 0 -50 -10 a 50 50 0 0 1 -50 -10 '));
        str = string(abi.encodePacked(str, 'a 50 50 0 0 1 -45 10 a 120 120 0 0 0 -5 50" '));
        str = string(abi.encodePacked(str, '" style="fill: ', _colors[rand%35], '; stroke: none; stroke-width: 0.2"/>'));

        str = string(abi.encodePacked(str, '<path d="M 160,140 a 30 30 0 0 0 -40 -10 a 30 30 0 0 0 35 10 z"  style="fill:white;stroke:black;stroke-width:2" />'));
        str = string(abi.encodePacked(str, '<circle cx="142" cy="133" r="6" style="fill:black" /> <circle cx="142" cy="132" r="1" style="fill:white" />'));
        str = string(abi.encodePacked(str, '<path d="M 200,140 a 30 30 0 0 1 40 -10 a 30 30 0 0 1 -35 10 z" style="fill:white;stroke:black;stroke-width:2" />'));
        str = string(abi.encodePacked(str, '<circle cx="217" cy="133" r="6" style="fill:black" /> <circle cx="217" cy="132" r="1" style="fill:white" />'));
        str = string(abi.encodePacked(str, '<path d="M 160,139 a 30 30 0 0 0 -40 -10" style="fill:none;stroke:black;stroke-width:4" />'));
        str = string(abi.encodePacked(str, '<path d="M 200,139 a 30 30 0 0 1 40 -10" style="fill:none;stroke:black;stroke-width:4" />'));
        str = string(abi.encodePacked(str, '<path d="M 120,129 a 30 30 0 0 1 -8 -5" style="fill:black;stroke:black;stroke-width:4" />'));
        str = string(abi.encodePacked(str, '<path d="M 240,129 a 30 30 0 0 0 8 -5" style="fill:black;stroke:black;stroke-width:4" />'));

        return str;
    }

    function tokenURI(uint256 tokenId) override public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("BACKGROUND", Strings.toString(tokenId))));

        string[64] memory parts;
		uint256 counter = 0;
        parts[counter++] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">';
		parts[counter++] = '<rect width="100%" height="100%" fill="';
        parts[counter++] = _colors[rand%35];
        parts[counter++] = '" />';
        parts[counter++] = pluckHair(tokenId);
        parts[counter++] = pluckBody(tokenId);
        parts[counter++] = pluckClothes(tokenId);
        parts[counter++] = '</svg>';

        string memory output = "";
		for(uint256 i = 0; i < counter; ++i)
		{
			output = string(abi.encodePacked(output, parts[i]));
		}

        string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Gal #', Strings.toString(tokenId), '", "description": "Gals in Metaverse", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
        output = string(abi.encodePacked('data:application/json;base64,', json));

        return output;
    }

    function mintPlayer(uint256 tokenId) public nonReentrant onlyOwner {
        require(tokenId > 0 && tokenId < 129, "Token ID invalid");
        _safeMint(owner(), tokenId);
    }
}
