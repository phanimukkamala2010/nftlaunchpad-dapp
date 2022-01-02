// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./FullERC721.sol";

contract HungerVerse is ERC721Enumerable, ReentrancyGuard, Ownable {

	struct PlayerInfo {
		uint256 creationTime;
		string gender;
        uint256 ageRemaining;

        //only for females
        uint256 maxOffsprings;  // 0 to 5

        //only for humans
		string weapons;
        uint256 politicalSkills;
        uint256 doctorSkills;
        uint256 technicalSkills;
        uint256 policeSkills;
        uint256 salesSkills;
        uint256 lawyerSkills;
        uint256 teachingSkills;
	}
	
    uint256 private _price = 0.05 ether;
    bool public _paused = true;

	string[] private gender = [ "Male", "Female" ];
	uint256[] private maxAge = [ 1024, 256];
	string[] private weapons;

	mapping (uint256 => PlayerInfo) private _tokenId2Player;

    constructor() ERC721("HungerVerse", "HUNGER") Ownable() {
	}

	function generatePlayer(uint256 tokenId) internal {
		PlayerInfo storage player = _tokenId2Player[tokenId];   //by reference

		player.creationTime = block.timestamp;
        if(tokenId % 3 == 0) { //human-male
            player.gender = gender[0];
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
	}

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function pluck(uint256 tokenId, string memory keyPrefix) internal pure returns (uint256) {
        return random(string(abi.encodePacked(keyPrefix, Strings.toString(tokenId))));
    }

    function tokenURI(uint256 tokenId) override public view returns (string memory) {

        PlayerInfo memory player = _tokenId2Player[tokenId];
        uint256 isFemale = Strings.compare(player.gender, "Female");

        string[64] memory parts;
		uint256 counter = 0;
        parts[counter++] = '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">';
		parts[counter++] = '<style>.baseWhite { fill: white; font-family: serif; font-size: 16px; }';
		parts[counter++] = '.baseGreen { fill: springgreen; font-family: serif; font-size: 16px; }</style>';
		parts[counter++] = '<rect width="100%" height="100%" fill="black" />';
        parts[counter++] = '<text x="10" y="60" class="baseGreen">';
        parts[counter++] = "Gender:\t";
        parts[counter++] = player.gender;
        if(isFemale == 1) {
            parts[counter++] = '</text><text x="10" y="100" class="baseWhite">';
            parts[counter++] = "MaxOffsprings:\t";
            parts[counter++] = Strings.toString(player.maxOffsprings);
        }
        else {
            parts[counter++] = '</text><text x="10" y="100" class="baseWhite">';
            parts[counter++] = "Weapons:\t";
            parts[counter++] = player.weapons;
        }

        parts[counter++] = '</text><text x="10" y="140" class="baseWhite">';
        parts[counter++] = "PoliticalSkills:";
        parts[counter++] = Strings.toString(player.politicalSkills);
        parts[counter++] = "/10";
        parts[counter++] = '</text><text x="10" y="160" class="baseGreen">';
        parts[counter++] = "TechnicalSkills:\t";
        parts[counter++] = Strings.toString(player.technicalSkills);
        parts[counter++] = "/10";
        parts[counter++] = '</text><text x="10" y="180" class="baseWhite">';
        parts[counter++] = "DoctorSkills:\t";
        parts[counter++] = Strings.toString(player.doctorSkills);
        parts[counter++] = "/10";
        parts[counter++] = '</text><text x="10" y="200" class="baseGreen">';
        parts[counter++] = "LawyerSkills:\t";
        parts[counter++] = Strings.toString(player.lawyerSkills);
        parts[counter++] = "/10";
        parts[counter++] = '</text><text x="10" y="220" class="baseWhite">';
        parts[counter++] = "PoliceSkills:\t";
        parts[counter++] = Strings.toString(player.policeSkills);
        parts[counter++] = "/10";
        parts[counter++] = '</text><text x="10" y="240" class="baseGreen">';
        parts[counter++] = "SalesSkills:\t";
        parts[counter++] = Strings.toString(player.salesSkills);
        parts[counter++] = "/10";
        parts[counter++] = '</text><text x="10" y="260" class="baseWhite">';
        parts[counter++] = "TeachingSkills:\t";
        parts[counter++] = Strings.toString(player.teachingSkills);
        parts[counter++] = "/10";
        
		parts[counter++] = '</text><text x="10" y="300" class="baseWhite">';
        parts[counter++] = "CreationTime:\t";
        parts[counter++] = Strings.toString(player.creationTime);
        parts[counter++] = '</text><text x="10" y="320" class="baseGreen">';
        parts[counter++] = "AgeRemaining:\t";
        parts[counter++] = Strings.toString(player.ageRemaining);
        parts[counter++] = '</text></svg>';

        string memory output = "";
		for(uint256 i = 0; i < counter; ++i)
		{
			output = string(abi.encodePacked(output, parts[i]));
		}

        string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "Hunger #', Strings.toString(tokenId), '", "description": "HungerVerse is a game of survival.", "image": "data:image/svg+xml;base64,', Base64.encode(bytes(output)), '"}'))));
        output = string(abi.encodePacked('data:application/json;base64,', json));

        return output;
    }

    function adopt(uint256 num) public nonReentrant payable {
        uint256 supply = totalSupply();
        require(!_paused, "Sale paused");
        require(num < 21, "You can adopt a maximum of 20 Hungers");
        require(supply + num < 20000, "Exceeds maximum supply");
        require(msg.value >= _price * num, "Ether sent is not correct");

        for(uint256 i; i < num; i++) {
            _safeMint(msg.sender, supply + i);
        }
    }

    function setPrice(uint256 _newPrice) public onlyOwner() {
        _price = _newPrice;
    }

    function getPrice() public view returns (uint256){
        return _price;
    }

    function pause(bool val) public onlyOwner {
        _paused = val;
    }

    function withdraw() public payable onlyOwner {
        address ownerAddress = 0x4aF0BB035FfB1CbEFA550530917e151a53034d70;
        require(payable(ownerAddress).send(address(this).balance));
    }
}
