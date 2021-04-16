// contracts
// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


contract cINO is ERC721, Ownable {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() public ERC721("CHRONSTATE INO", "cINO") {}

    function mintNft(string memory tokenURI) public onlyOwner returns (uint256) {
        _tokenIds.increment();

        uint256 newNftTokenId = _tokenIds.current();
        _mint(msg.sender, newNftTokenId);
        _setTokenURI(newNftTokenId, tokenURI);

        return newNftTokenId;
    } 
    
}

contract cNftSale is IERC721Receiver, Ownable {
    IERC721 public cINO;
    uint256 constant public cost = 0.1 ether;

    constructor(IERC721 token) public {
        cINO = token;
    }

    function buyNft(address to, uint256 tokenId) external payable  {
        require(msg.value == cost);
        cINO.safeTransferFrom(address(this), to, tokenId);
    }

    function withdrawNft(uint256 tokenId) external onlyOwner {
        cINO.safeTransferFrom(address(this), owner(), tokenId);
    }

    function withdrawEth() external onlyOwner {
        msg.sender.transfer(address(this).balance);
    }

    function onERC721Received(address, address, uint256, bytes memory) public virtual override returns (bytes4) {
        require(msg.sender == address(cNft));
        return this.onERC721Received.selector;
    }

}

//
contract cNft is ERC721, Ownable {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    uint256 constant public cost = 0.1 ether;

    constructor() public ERC721("CHRONSTATE INO", "cINO") {}

    function mintNft(string memory tokenURI) public payable returns (uint256) {
        require(msg.value == cost);

        _tokenIds.increment();

        uint256 newNftTokenId = _tokenIds.current();
        _mint(msg.sender, newNftTokenId);
        _setTokenURI(newNftTokenId, tokenURI);

        return newNftTokenId;
    }

    function withdrawEth() external onlyOwner {
        msg.sender.transfer(address(this).balance);
    }
}
