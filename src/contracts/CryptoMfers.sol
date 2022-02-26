// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./FullERC721.sol";

contract CryptoMfers is ERC721Enumerable, Ownable {

    uint256 public _maxSupply = 12480;
    uint256 public _price = 0.069 ether;
    bool public _paused = false;
    
    string public constant _desc = "CryptoMfers - inspired by mfers, made for mfers";
    string public constant _mferURI = "http://nft-launchpad.io/cryptomfers/cryptomfer-";

    constructor() ERC721("CryptoMfers", "CRYPTOMFERS") Ownable() {
	}

    function _baseURI() override internal view virtual returns (string memory) {
        return _mferURI;
    }
    function mint(uint256 num) external payable {
        require(!_paused, "Sale paused");
        require(num > 0 && num < 101, "maximum of 100 cryptomfers");
        require(totalSupply() + num <= _maxSupply, "Exceeds maximum supply");
        require(msg.value >= _price * num, "Ether sent is not correct");

        uint256 count = 0;
        for(uint256 i = 1; i <= _maxSupply; i++) {
            if(_exists(i)) continue;
            _safeMint(msg.sender, i);
            if(++count == num) break;
        }
    }
    function setMaxSupply(uint256 newVal) external onlyOwner {
        _maxSupply = newVal;
    }
    function setPrice(uint256 _newPrice) external onlyOwner {
        _price = _newPrice;
    }
    function setPause(bool val) external onlyOwner {
        _paused = val;
    }
    function withdraw() external payable onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }
}
