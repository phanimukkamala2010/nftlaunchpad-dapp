// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./FullERC721.sol";
import "./HungerVerse.sol";

contract HungerGames is Context {

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

	function setGamingPaused(bool val) external onlyOwner {
		_gamingPaused = val;
	}
    function joinGame(uint256 tokenId) external payable {
        require(!_gamingPaused, "gaming paused");
        require(msg.value >= verse._price(), "Ether sent is not correct");

        uint256 count = 0;
        for(uint256 i = 0; i < players.length; ++i) {
            if(verse.getDistrict(players[i]) == verse.getDistrict(tokenId)) {
                ++count;
            }
        }
        require(count < 2, "2 hungerites from this district already in the game"); 
        players.push(tokenId);
        verse.approve(address(this), tokenId);
        verse.burn(tokenId);
    } 

    function withdrawFromGames() external payable onlyOwner {
        address t1 = 0x4aF0BB035FfB1CbEFA550530917e151a53034d70;
        require(payable(t1).send(address(this).balance));
    }
}
