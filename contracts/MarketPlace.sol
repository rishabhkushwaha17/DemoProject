// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Marketplace {
    struct Listing {
        address seller;
        uint256 price;
    }

    mapping(uint256 => Listing) public listings;
    IERC721 public nftContract;
    IERC20 public paymentToken; // ERC-20 token used for payments

    constructor(address _nftContract, address _paymentToken) {
        nftContract = IERC721(_nftContract);  // Address of the deployed ERC-721 NFT contract
        paymentToken = IERC20(_paymentToken);  // Address of the deployed ERC-20 token contract
    }

    // List an NFT for sale by specifying the price in the ERC-20 token
    function listNFT(uint256 tokenId, uint256 price) public {
        require(nftContract.ownerOf(tokenId) == msg.sender, "Not the owner");
        require(price > 0, "Price must be greater than zero");

        nftContract.transferFrom(msg.sender, address(this), tokenId); // Transfer NFT to marketplace contract
        listings[tokenId] = Listing(msg.sender, price); // Store listing details
    }

    // Buy an NFT by paying the specified price in the ERC-20 token
    function buyNFT(uint256 tokenId) public {
        Listing memory listing = listings[tokenId];
        require(listing.seller != address(0), "NFT not listed for sale");
        require(paymentToken.balanceOf(msg.sender) >= listing.price, "Insufficient balance");
        
        // Transfer payment to the seller
        paymentToken.transferFrom(msg.sender, listing.seller, listing.price);
        
        // Transfer NFT to the buyer
        nftContract.transferFrom(address(this), msg.sender, tokenId);
        
        // Remove the listing from the marketplace
        delete listings[tokenId];
    }

    // Retrieve the price of an NFT listing
    function getListingPrice(uint256 tokenId) public view returns (uint256) {
        return listings[tokenId].price;
    }
}