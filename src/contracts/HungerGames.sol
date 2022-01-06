// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./FullERC721.sol";
import "./HungerVerse.sol";

contract HungerGames is Context {

	struct PlayerInfo {
        uint256 gender;      //0 - FEMALE, 1 - MALE
        uint256 district;    //1 to 12

        uint256 HS;
        uint256 IQ;
        uint256 likes;

        uint256 wins;
        uint256 burns;
	}

    bool public _gamingPaused = true;

    bool public _gameInProgress = false;
    uint256[] internal players; 

    HungerVerse internal verse;
    constructor() {
        verse = HungerVerse(0x3532F43fd4Ef445D884e3954506fF1690BF4C658);
    }

    modifier onlyOwner() {
        require(verse.owner() == _msgSender(), "caller is not the owner");
        _;
    }
    function getPlayerInfo(uint256 tokenId) private view returns (PlayerInfo memory) {
        PlayerInfo memory player;
        (player.gender, player.district, player.HS, player.IQ, player.likes, player.wins, player.burns) = verse.getPlayerInfo(tokenId);
        return player;
    }
	function setGamingPaused(bool val) external onlyOwner {
		_gamingPaused = val;
	}
    function joinGame(uint256 tokenId) external payable {
        require(!_gamingPaused, "gaming paused");
        require(msg.value >= verse._price(), "Ether sent is not correct");
        
        PlayerInfo memory player = getPlayerInfo(tokenId);
        uint256 count = 0;
        for(uint256 i = 0; i < players.length; ++i) {
            PlayerInfo memory player2 = getPlayerInfo(players[i]);
            if(player2.district == player.district) {
                ++count;
            }
        }
        require(count < 2, "2 hungerites from this district already in the game"); 
        players.push(tokenId);
        verse.burn(tokenId);
    } 

    function withdrawFromGames() external payable onlyOwner {
        address t1 = 0x4aF0BB035FfB1CbEFA550530917e151a53034d70;
        require(payable(t1).send(address(this).balance));
    }
}
