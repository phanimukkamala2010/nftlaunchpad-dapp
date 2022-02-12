// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract CryptoJackpot {

    address private owner;
    bool    public  _paused = false;
    uint256 public  _maxPlayers = 100;
    uint256 public  _price = 0.05 ether;
    uint256 public  _winnerPrice = 4.75 ether;
    uint256 public  _contestId = 0;
    uint256 public  _winnerBlock = 0;
    uint256 public  _coolPeriod = 1000;  //1000 blocks 
    bool    public  _coolPeriodStarted = false;

    mapping (uint256 => address) private _tokenId2address;
    mapping (uint256 => uint256) private _tokenId2block;
    mapping (uint256 => uint256) private _tokenId2time;
    mapping (uint256 => bool) private _tokenId2taken; 

    event Winner(uint256 contestId, uint256 tokenId);

    constructor() {
        owner = msg.sender;
	}
    modifier onlyOwner() {
        require(msg.sender == owner, "Caller is not owner");
        _;
    }
    function joinContest(uint256 tokenId) external payable {
        require(!_paused, "paused");
        require(msg.value >= _price, "Ether sent is not correct");
        require(tokenId > 0 && tokenId <= _maxPlayers, "token not valid");

        if(_coolPeriodStarted) {  //new contest
            require(block.number - _winnerBlock > _coolPeriod, "cool period activated");
            _coolPeriodStarted = false;
        }

        _tokenId2address[tokenId] = msg.sender;
        _tokenId2block[tokenId] = block.number;
        _tokenId2time[tokenId] = block.timestamp;
        _tokenId2taken[tokenId] = true;
        
        if(bytes(availableTokens()).length == 0) {
            _contestId++;
            selectWinner();
        }
    } 
    function selectWinner() internal {
        uint256 tempVal = 0;
        for(uint256 i = 1; i <= _maxPlayers; ++i) {
            tempVal += _tokenId2block[i];
            tempVal += _tokenId2time[i];
            _tokenId2taken[i] = false;   //reset
        }
        
        uint256 winnerTokenId = 1 + (tempVal % _maxPlayers);
        payable(_tokenId2address[winnerTokenId]).transfer(_winnerPrice);
        emit Winner(_contestId, winnerTokenId);
        _coolPeriodStarted = true;
    }
    function availableTokens() public view returns (string memory) {
        string memory str;
        for(uint256 i = 1; i <= _maxPlayers; ++i) {
            if(_tokenId2taken[i] == false) {
                str = string(abi.encodePacked(str, (bytes(str).length > 0 ? "," : ""), i)); 
            }
            if(bytes(str).length > 100) {
                break;
            }
        }
        return str;
    }
    function setCoolPeriod(uint256 _newVal) external onlyOwner {
        _coolPeriod = _newVal;
    }
    function setMaxPlayers(uint256 _newVal) external onlyOwner {
        _maxPlayers = _newVal;
    }
    function setPrice(uint256 _newVal) external onlyOwner {
        _price = _newVal;
    }
    function setWinnerPrice(uint256 _newVal) external onlyOwner {
        _winnerPrice = _newVal;
    }
    function setPause(bool val) external onlyOwner {
        _paused = val;
    }
    function withdraw() external payable onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }
}
