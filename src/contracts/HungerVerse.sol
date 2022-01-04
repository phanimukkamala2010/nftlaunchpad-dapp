// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./FullERC721.sol";

contract HungerVerse is ERC721Enumerable, ReentrancyGuard, Ownable {

	struct PlayerInfo {
        uint256 state;       //0 - burnt, 1 - active
		uint256 gender;      //0 - FEMALE, 1 - MALE
        uint256 district;    //1 to 12

        //only for females
        uint256 offsprings;  // 0 to 8

        //gifted = 4, above average = 3, average = 2, below average = 1
        uint256 huntingSkills;
        uint256 IQ;
        uint256 likes;

        uint256 wins;
        uint256 burns;
        uint256 winsSinceLastBurn;
	}
	
    uint256 private _price = 0.05 ether;
    bool public _paused = true;
    bool public _matingPaused = true;
    bool public _reclaimPaused = true;

	mapping (uint256 => PlayerInfo) private _tokenId2Player;

    constructor() ERC721("HungerVerse", "HUNGER") Ownable() {
	}

	function generatePlayer(uint256 tokenId) internal {
		PlayerInfo storage player = _tokenId2Player[tokenId];   //by reference

        player.state = 1;
        player.gender = pluck(tokenId, "GENDER") % 2;
        player.district = 1 + pluck(tokenId, "DISTRICT") % 12;
        if(player.gender == 0) {
            player.offsprings = pluck(tokenId, "OFFSPRINGS") % 9;
        }
        player.huntingSkills = 1 + (player.burns + pluck(tokenId, "HUNTING")) % 4;
        player.IQ = 1 + (player.burns + pluck(tokenId, "IQSCORE")) % 4;
        player.winsSinceLastBurn = 0;
	}

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function pluck(uint256 tokenId, string memory keyPrefix) internal pure returns (uint256) {
        return random(string(abi.encodePacked(keyPrefix, Strings.toString(tokenId))));
    }

    function tokenURI(uint256 tokenId) override public view returns (string memory) {

        PlayerInfo memory player = _tokenId2Player[tokenId];

        string[64] memory parts;
		uint256 counter = 0;
        parts[counter++] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">';
		parts[counter++] = '<style>.baseWhite { fill: white; font-family: serif; font-size: 16px; }';
		parts[counter++] = '.baseGreen { fill: springgreen; font-family: serif; font-size: 16px; }</style>';
		parts[counter++] = '<rect width="100%" height="100%" fill="black" />';
        parts[counter++] = '<text x="10" y="60" class="baseGreen">';
        parts[counter++] = "Gender:\t";
        parts[counter++] = (player.gender == 0 ? "Female" : "Male");
        if(player.gender == 0) {
            parts[counter++] = '</text><text x="10" y="100" class="baseWhite">';
            parts[counter++] = "MaxOffsprings:\t";
            parts[counter++] = Strings.toString(player.offsprings);
        }

        parts[counter++] = '</text></svg>';

        string memory output = "";
		for(uint256 i = 0; i < counter; ++i)
		{
			output = string(abi.encodePacked(output, parts[i]));
		}

        string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Hungerite #', Strings.toString(tokenId), '", "description": "HungerVerse is a game of survival.", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
        output = string(abi.encodePacked('data:application/json;base64,', json));

        return output;
    }

    function ownHungerites(uint256 num) public nonReentrant payable {
        uint256 supply = totalSupply();
        require(!_paused, "Sale paused");
        require(num > 0 && num < 21, "You can adopt a maximum of 20 Hungerite");
        require(supply + num < 24000, "Exceeds maximum supply");
        require(msg.value >= _price * num, "Ether sent is not correct");

        for(uint256 i = 0; i < num; i++) {
            generatePlayer(supply + i);
            _safeMint(msg.sender, supply + i);
        }
    }
    function reclaimHungerites(uint256 num) public nonReentrant payable {
        uint256 supply = totalSupply();
        require(!_reclaimPaused, "reclaim paused");
        require(num > 0 && num < 21, "You can adopt a maximum of 20 Hungerite");
        require(supply + num < 24000, "Exceeds maximum supply");
        require(msg.value >= _price * num, "Ether sent is not correct");

        uint256 count = 0;
        for(uint256 i = 0; i < 24000; i++) {
            if(_tokenId2Player[i].state == 1) continue;
            generatePlayer(i);
            _safeMint(msg.sender, i);
            if(++count == num) break;
        }
    }
    function mate(uint256 tokenIdM, uint256 tokenIdF) public nonReentrant {
        uint256 supply = totalSupply();
        require(!_matingPaused, "Mating paused");
        require(_isApprovedOrOwner(msg.sender, tokenIdM), "not authorized");
        require(_isApprovedOrOwner(msg.sender, tokenIdF), "not authorized");
        PlayerInfo memory male = _tokenId2Player[tokenIdM];
        require(male.gender == 1, "first token should be male");
        PlayerInfo storage female = _tokenId2Player[tokenIdF];
        require(female.gender == 0, "second token should be female");
        require(female.offsprings > 0, "no offsprings");
        require(supply + female.offsprings < 24000, "Exceeds maximum supply");

        uint256 count = 0;
        for(uint256 i; i < 24000; i++) {
            if(_tokenId2Player[i].state == 1) continue;
            generatePlayer(i);
            _safeMint(msg.sender, i);
            if(++count == female.offsprings) break;
        }
        female.offsprings = 0;
    }
    function burn(uint256 tokenId) public {
        require(_isApprovedOrOwner(msg.sender, tokenId), "not authorized");
        PlayerInfo storage player = _tokenId2Player[tokenId];
        player.state = 0;
        player.burns++;
        _burn(tokenId);
    }
    function setPrice(uint256 _newPrice) public onlyOwner {
        _price = _newPrice;
    }
    function getPrice() public view returns (uint256) {
        return _price;
    }
    function setPause(bool val) public onlyOwner {
        _paused = val;
    }
    function setMatingPause(bool val) public onlyOwner {
        _matingPaused = val;
    }
    function setReclaimPause(bool val) public onlyOwner {
        _reclaimPaused = val;
    }
    function withdraw() public payable onlyOwner {
        address ownerAddress = 0x4aF0BB035FfB1CbEFA550530917e151a53034d70;
        require(payable(ownerAddress).send(address(this).balance));
    }
}
