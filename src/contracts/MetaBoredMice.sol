// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./FullERC721.sol";

contract MetaBoredMice is ERC721Enumerable, ReentrancyGuard, Ownable {

        constructor() ERC721("MetaBoredMice", "METABOREDMICE") Ownable() {
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
                "plum",
                "gold",
                "silver"
                        ];

        function random(string memory input) internal pure returns (uint256) {
                return uint256(keccak256(abi.encodePacked(input)));
        }

        function pluckBody(uint256 tokenId) internal view returns (string memory) {
                uint256 rand = random(string(abi.encodePacked("BODY", Strings.toString(tokenId))));
                string memory str = "";

                str = string(abi.encodePacked(str, '<path d="M 90 190 a 30 10 0 0 0 30 25 l 2 2 a 30 10 0 0 1 -30 -25" '));
                str = string(abi.encodePacked(str, 'style="fill:black;stroke:black;stroke-width:1" />'));
                str = string(abi.encodePacked(str, '<path d="M 320,150 a 90 90 0 0 0 -50 -30 a 10 30 0 0 0 -30 -20 '));
                str = string(abi.encodePacked(str, 'a 10 30 0 0 0 -30 20 a 50 40 0 0 0 -120 90 a 30 30 0 0 0 40 10 '));
                str = string(abi.encodePacked(str, 'a 50 50 0 0 0 20 10 a 50 30 0 0 0 30 -10 a 90 90 0 0 0 70 -30 '));
                str = string(abi.encodePacked(str, 'a 90 90 0 0 0 70 -30 z" style="fill:'));
                str = string(abi.encodePacked(str, _colors[rand%36], ';stroke:black;stroke-width:0.3" />'));
                str = string(abi.encodePacked(str, '<circle cx="280" cy="140" r="6" style="fill:white;stroke:black;stroke-width:0.3" />'));
                str = string(abi.encodePacked(str, '<circle cx="282" cy="139" r="4" style="fill:black;stroke:black;stroke-width:0.3" >'));
                str = string(abi.encodePacked(str, '<animateTransform attributeName="transform" type="rotate" from="0 280 139" to="360 280 139" '));
                str = string(abi.encodePacked(str, 'begin="0s" dur="10s" repeatCount="indefinite" /> </circle>'));
                str = string(abi.encodePacked(str, ' <path d="M 310 160 a 30 30 0 0 0 -10 25" style="fill:none;stroke:black;stroke-width:2" />'));
                str = string(abi.encodePacked(str, '<path d="M 305 160 a 30 30 0 0 0 -20 20" style="fill:none;stroke:black;stroke-width:2" />'));
                str = string(abi.encodePacked(str, '<path d="M 300 160 a 30 30 0 0 0 -30 20" style="fill:none;stroke:black;stroke-width:2" />'));
                str = string(abi.encodePacked(str, '<path d="M 320,150 a 10 10 0 0 0 -5 5 a 10 10 0 0 0 5 5" style="black:none;stroke:black;stroke-width:2" />'));

                return str;
        }

        function tokenURI(uint256 tokenId) override public view returns (string memory) {

                string[64] memory parts;
                uint256 counter = 0;
                parts[counter++] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">';
                parts[counter++] = '<rect width="100%" height="100%" fill="honeydew" />';
                parts[counter++] = pluckBody(tokenId);
                parts[counter++] = '</svg>';

                string memory output = "";
                for(uint256 i = 0; i < counter; ++i)
                {
                        output = string(abi.encodePacked(output, parts[i]));
                }

                string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Mouse #', Strings.toString(tokenId), '", "description": "Bored Mice in Metaverse", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
                output = string(abi.encodePacked('data:application/json;base64,', json));

                return output;
        }

        function mintPlayer(uint256 tokenId) public nonReentrant onlyOwner {
                require(tokenId > 0 && tokenId < 129, "Token ID invalid");
                _safeMint(owner(), tokenId);
        }
}
