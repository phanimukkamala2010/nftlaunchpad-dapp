// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./FullERC721.sol";

contract CryptoBabes is ERC721Enumerable, Ownable {

    uint256 public constant _maxSupply = 1000;
    uint256 public _price = 0.05 ether;
    bool public _paused = false;
    
    string public constant _desc = "CryptoBabes is a unique collection of babes on the beach - dedicated to all the women who make our lives better everyday";
    string public constant _babeURI = "http://nft-launchpad.io/cryptobabes/cryptobabe-";

    mapping (uint256 => string) private _tokenId2image;

    constructor() ERC721("CryptoBabes", "CRYPTOBABE") Ownable() {
	}

    function tokenURI(uint256 tokenId) override public view returns (string memory) {
        string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "NFTLP #', Strings.toString(tokenId), 
                            '", "description": "', _desc, '", "image": "data:image/svg+xml;base64,', 
                            Base64.encode(bytes(_tokenId2image[tokenId])), '"}'))));
        string memory output = string(abi.encodePacked('data:application/json;base64,', json));
        return output;
    }
    function mint(uint256 tokenId) external payable {
        require(!_paused, "Sale paused");
        require(tokenId > 0 && totalSupply() <= _maxSupply, "Exceeds maximum supply");
        require(msg.value >= _price, "Ether sent is not correct");
        _tokenId2image[tokenId] = string(abi.encodePacked(_babeURI, tokenId));
        _safeMint(msg.sender, tokenId);
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
