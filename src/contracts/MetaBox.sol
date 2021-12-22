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

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function pluckHead(uint256 tokenId) internal view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("HEAD", Strings.toString(tokenId))));
        string memory str = "";
        if(rand%5 == 0) {
            str = string(abi.encodePacked(str, '<path d="M 100 120 l 10 120 l 120 -10 l -10 -120 l -120 10 " style="fill: '));
        }
        else if(rand%5 == 1) {
            str = string(abi.encodePacked(str, '<path d="M 100 235 l 140 -10 l -80 -120 l -55 120 " style="fill: '));
        }
        else if(rand%5 == 2) {
            str = string(abi.encodePacked(str, '<path d="M 80 235 l 180 -10 l -10 -90 l -180 10 l 10 90 " style="fill: '));
        }
        else if(rand%5 == 3) {
            str = string(abi.encodePacked(str, '<path d="M 110 180 a 60 60 0 0 0 60 60 a 60 60 0 0 0 60 -60 a 60 60 0 0 0 -60 -60 a 60 60 0 0 0 -60 60 " style="fill: '));
        }
        else if(rand%5 == 4) {
            str = string(abi.encodePacked(str, '<path d="M 105 160 a 60 80 -10 0 0 60 80 a 60 80 -10 0 0 60 -80 a 60 80 -10 0 0 -60 -80 a 60 80 -10 0 0 -60 80 " style="fill: '));
        }
        str = string(abi.encodePacked(str, _colors[rand%35], '; stroke: none; stroke-width: 0.5"/>'));
        return str;
    }

    function pluckTie(uint256 tokenId) internal view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("TIE", Strings.toString(tokenId))));
        string memory str = "";
        if(rand%2 == 0) {
            str = string(abi.encodePacked(str, '<path d="M 130 270 a 50 5 0 0 0 85 0 l 10 5 a 50 5 0 0 1 -45 5 l 5 50 l -15 10 l -15 -10 '));
            str = string(abi.encodePacked(str, 'l 5 -50 a 50 5 0 0 1 -48 -5 " style="fill: '));
        }
        else {
            str = string(abi.encodePacked(str, '<path d="M 130 275 a 50 50 0 0 0 0 30 l 30 -10 l 20 0 l 30 10 a 50 50 0 0 0 0 -30 '));
            str = string(abi.encodePacked(str, 'l -30 10 l -20 0 l -30 -10 " style="fill: '));
        }
        str = string(abi.encodePacked(str, _colors[rand%35], '; stroke: none; stroke-width: 0.5"/>'));
        return str;
    }

    function pluckShirt(uint256 tokenId) internal view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("SHIRT", Strings.toString(tokenId))));
        string memory str = "";
        if(rand%2 == 0) {
            str = string(abi.encodePacked(str, '<path d="M 170 300 l -40 -30 l -72 15 l -25 70 h 275 0 l -30 -70 l -72 -15 l -40 30 '));
        }
        else {
            str = string(abi.encodePacked(str, '<path d="M 120 278 l -10 1 l 1 25 l 2 25 l -1 25 h 130 l -2 -25 l -2 -25 l -2 -25 l -10 -1 '));
            str = string(abi.encodePacked(str, 'v 25 a 52 52 0 0 1 -52 40 a 52 52 0 0 1 -52 -40 v -25 '));
        }
        str = string(abi.encodePacked(str, '" style="fill: ', _colors[rand%35], '; stroke: none; stroke-width: 0.5"/>'));
        return str;
    }

    function pluckBody(uint256 tokenId) internal view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("BODY", Strings.toString(tokenId))));
        string memory str = "";
        str = string(abi.encodePacked(str, '<path d="M 140 225 l 1 4 l 2 6 l 0 8 l -2 10 l -2 8 l -4 10 l -4 4 l -8 1 l -8 1 '));
        str = string(abi.encodePacked(str, 'l -8 1 l -8 1 l -8 1 l -8 1 l -8 4 l -8 6 l -8 8 l -8 10 l -8 20 l -8 30 '));
        str = string(abi.encodePacked(str, 'l -8 40 h 285 l -8 -40 l -8 -30 l -8 -20 l -8 -10 l -8 -8 l -8 -6 l -8 -4 l -8 -1 '));
        str = string(abi.encodePacked(str, 'l -8 -1 l -8 -1 l -8 -1 l -8 -1 l -8 -1 l -4 -4 l -4 -10 l -2 -8 l -2 -10 l 0 -8 '));
        str = string(abi.encodePacked(str, 'l 2 -6 l 1 -4 h -60 " style="fill: ', _colors[rand%35]));
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

    function addArmpits() internal pure returns (string memory) {
        string memory str = "";
        str = string(abi.encodePacked(str, '<path d="M 100 320 l -4 20 l -4 40 l -4 40 " style="fill: none; stroke: grey; stroke-width: 1" />'));
        str = string(abi.encodePacked(str, '<path d="M 101 320 l -4 20 l -4 40 l -4 40 " style="fill: none; stroke: grey; stroke-width: 1" />'));
        str = string(abi.encodePacked(str, '<path d="M 240 320 l 4 20 l 4 40 l 4 40 " style="fill: none; stroke: grey; stroke-width: 1" />'));
        str = string(abi.encodePacked(str, '<path d="M 241 320 l 4 20 l 4 40 l 4 40 " style="fill: none; stroke: grey; stroke-width: 1" />'));
        str = string(abi.encodePacked(str, '<path d="M 58 285 l 20 15 l 20 20 " style="fill: grey; stroke: grey; stroke-width: 1" />'));
        str = string(abi.encodePacked(str, '<path d="M 58 286 l 20 15 l 20 20 " style="fill: grey; stroke: grey; stroke-width: 1" />'));
        str = string(abi.encodePacked(str, '<path d="M 280 285 l -20 15 l -20 20 " style="fill: grey; stroke: grey; stroke-width: 1" />'));
        str = string(abi.encodePacked(str, '<path d="M 280 286 l -20 15 l -20 20 " style="fill: grey; stroke: grey; stroke-width: 1" />'));
        return str;
    }

    function tokenURI(uint256 tokenId) override public view returns (string memory) {

        string[64] memory parts;
		uint256 counter = 0;
        parts[counter++] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">';
		parts[counter++] = '<rect width="100%" height="100%" fill="black" />';
        parts[counter++] = pluckBody(tokenId);
        parts[counter++] = pluckShirt(tokenId);
        parts[counter++] = pluckTie(tokenId);
        parts[counter++] = pluckHead(tokenId);
        parts[counter++] = addArmpits();
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
