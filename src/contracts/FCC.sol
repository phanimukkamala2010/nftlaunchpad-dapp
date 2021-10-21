// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./FullERC20.sol";

contract FantasyCricketCoin is ERC20 {

    constructor() ERC20("FantasyCricketCoin", "FCC") {
    }

    uint256 private MAX_CURRENT_SUPPLY = 11 * 1000 * 1000;  //11 million

    function mintCoin() external {
        require(super.totalSupply() < MAX_CURRENT_SUPPLY, "cannot mint anymore coins");
        require(super.balanceOf(_msgSender()) == 0, "address cannot mint anymore coins");
        _mint(_msgSender(), 100);
    }

    function ownerMintCoin(uint256 amount) external onlyOwner {
        _mint(_msgSender(), amount);
    }
}
