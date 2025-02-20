// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SmartHomes is ERC721URIStorage, Ownable {
    uint256 counter;
    mapping(address =>uint256[]) holdingId;
    event Minted(address indexed to, uint256 indexed tokenId);
    event Burned(uint256 indexed tokenId);
    constructor()Ownable(msg.sender) ERC721("Smart Home HQ", "SHHQ") {}
    function mint(address to,uint256 tokenId, string memory tokenURI) external {
            _safeMint(to, tokenId);
            _setTokenURI(tokenId, tokenURI);
            holdingId[to].push(tokenId);
            counter++ ;
            emit Minted(to, tokenId);
    }
    function burn(uint256 tokenId) external {
        _burn(tokenId);
        //delete holdingId[msg.sender][tokenId-1];
        emit Burned(tokenId);
    }
    function getHoldingId(address owner) public view returns (uint256[] memory){
        return holdingId[owner];
    }
    function getNFTCounter() external view returns(uint256){
        return counter;
    }
}
