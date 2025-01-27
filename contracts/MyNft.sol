// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyNFT is ERC721, Ownable {
    uint256 public nextTokenId;

    // Mapping to store the metadata URIs for each tokenId
    mapping(uint256 => string) private _metadataURIs;

    // Constructor to initialize the ERC721 token and set the contract owner
    constructor() Ownable(msg.sender) ERC721("MyNFT", "MNFT") {}

    /**
     * @notice Mints a new NFT to the specified address with metadata URI
     * @param to The address of the collector to receive the NFT
     * @param metadataURI The metadata URI associated with the NFT
     */
    function mint(address to, string memory metadataURI) public onlyOwner {
        uint256 tokenId = nextTokenId;
        _safeMint(to, tokenId);
        _metadataURIs[tokenId] = metadataURI;
        nextTokenId++;
    }
    /**
     * @notice Returns the metadata URI of a specific token
     * @param _tokenId The ID of the token
     * @return The URI of the token
     */
    function tokenURI(
        uint256 _tokenId
    ) public view override returns (string memory) {
        // Return the metadata URI associated with the given tokenId
        return _metadataURIs[_tokenId];
    }
}
