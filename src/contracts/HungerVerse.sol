// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./FullERC721.sol";

contract HungerVerse is ERC721Enumerable, ReentrancyGuard, Ownable {

	struct PlayerInfo {
        string name;
        uint256 state;       //0 - burnt, 1 - active
        uint256 gender;      //0 - FEMALE, 1 - MALE
        uint256 district;    //1 to 12

        //only for females
        uint256 offsprings;  // 0 to 8

        //gifted = 3, above average = 2, average = 1, below average = 0
        uint256 huntingSkills;
        uint256 IQ;
        uint256 likes;

        uint256 wins;
        uint256 burns;
	}
    string[] private gender = [ "Female", "Male" ];
    string[] private skills = [ "Below Average", "Average", "Above Average", "Gifted" ];
	
    uint256 public _price = 0.05 ether;
    bool public _paused = true;
    bool public _matingPaused = true;
    bool public _reclaimPaused = true;

    mapping (uint256 => PlayerInfo) public _tokenId2Player;

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
        player.huntingSkills = (player.wins + player.burns + pluck(tokenId, "HUNTING")) % 4;
        player.IQ = (player.wins + player.burns + pluck(tokenId, "IQSCORE")) % 4;
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
        parts[counter++] = gender[player.gender];
        parts[counter++] = '</text><text x="10" y="100" class="baseWhite">';
        parts[counter++] = "Name:\t";
        parts[counter++] = bytes(player.name).length > 0 ? player.name : '';

        if(player.gender == 0) {
            parts[counter++] = '</text><text x="10" y="120" class="baseWhite">';
            parts[counter++] = "Offsprings:\t";
            parts[counter++] = Strings.toString(player.offsprings);
        }
        parts[counter++] = '</text><text x="10" y="180" class="baseWhite">';
        parts[counter++] = "HuntingSkills:\t";
        parts[counter++] = skills[player.huntingSkills];
        parts[counter++] = '</text><text x="10" y="200" class="baseWhite">';
        parts[counter++] = "IQ:\t";
        parts[counter++] = skills[player.IQ];
        parts[counter++] = '</text><text x="10" y="220" class="baseWhite">';
        parts[counter++] = "Likes:\t";
        parts[counter++] = Strings.toString(player.likes);
        parts[counter++] = '</text><text x="10" y="260" class="baseWhite">';
        parts[counter++] = "wins:\t";
        parts[counter++] = Strings.toString(player.wins);
        parts[counter++] = '</text><text x="10" y="280" class="baseWhite">';
        parts[counter++] = "burns:\t";
        parts[counter++] = Strings.toString(player.burns);

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
        require(supply + num <= 24000, "Exceeds maximum supply");
        require(msg.value >= _price * num, "Ether sent is not correct");

        for(uint256 i = 1; i <= num; i++) {
            generatePlayer(supply + i);
            _safeMint(msg.sender, supply + i);
        }
    }
    function reclaimHungerites(uint256 num) public payable {
        uint256 supply = totalSupply();
        require(!_reclaimPaused, "reclaim paused");
        require(num > 0 && num < 21, "You can adopt a maximum of 20 Hungerite");
        require(supply + num <= 24000, "Exceeds maximum supply");
        require(msg.value >= _price * num, "Ether sent is not correct");

        uint256 count = 0;
        for(uint256 i = 1; i <= 24000; i++) {
            if(_tokenId2Player[i].state == 1) continue;
            generatePlayer(i);
            _safeMint(msg.sender, i);
            if(++count == num) break;
        }
    }
    function mate(uint256 tokenIdM, uint256 tokenIdF) public {
        uint256 supply = totalSupply();
        require(!_matingPaused, "Mating paused");
        require(_isApprovedOrOwner(msg.sender, tokenIdM), "not authorized");
        require(_isApprovedOrOwner(msg.sender, tokenIdF), "not authorized");
        PlayerInfo memory male = _tokenId2Player[tokenIdM];
        require(male.gender == 1, "first token should be male");
        PlayerInfo storage female = _tokenId2Player[tokenIdF];
        require(female.gender == 0, "second token should be female");
        require(female.offsprings > 0, "no offsprings");
        require(supply + female.offsprings <= 24000, "Exceeds maximum supply");

        uint256 count = 0;
        for(uint256 i = 1; i <= 24000; i++) {
            if(_tokenId2Player[i].state == 1) continue;
            generatePlayer(i);
            _safeMint(msg.sender, i);
            if(++count == female.offsprings) break;
        }
        female.offsprings = 0;
    }
	function like(uint256 tokenId) public {
		PlayerInfo storage player = _tokenId2Player[tokenId];
		player.likes++;
	}
	function setMatingPause(bool val) public onlyOwner {
		_matingPaused = val;
	}
	function setReclaimPause(bool val) public onlyOwner {
		_reclaimPaused = val;
	}
    function getDistrict(uint256 tokenId) external view returns (uint256) {
        return _tokenId2Player[tokenId].district;
    }
    function burn(uint256 tokenId) public {
        require(_isApprovedOrOwner(msg.sender, tokenId), "not authorized");
        PlayerInfo storage player = _tokenId2Player[tokenId];
        player.state = 0;
        player.burns++;
        _burn(tokenId);
    }
    function setName(uint256 tokenId, string memory val) public {
        require(_isApprovedOrOwner(msg.sender, tokenId), "not authorized");
        PlayerInfo storage player = _tokenId2Player[tokenId];
        player.name = val;
    }
    function setPrice(uint256 _newPrice) public onlyOwner {
        _price = _newPrice;
    }
    function setPause(bool val) public onlyOwner {
        _paused = val;
    }
    function withdraw() public payable onlyOwner {
        address t1 = 0x4aF0BB035FfB1CbEFA550530917e151a53034d70;
        require(payable(t1).send(address(this).balance));
    }
}
