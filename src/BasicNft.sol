// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

// A URL (Uniform Resource Locator) provides the location of a resource.abi
// A URI (Uniform Resource Identifier) identifies the resource by name at the specified location or URL.
contract BasicNft is ERC721 {
    uint256 private s_tokenCounter;
    mapping(uint256 => string) private s_tokenIdToUri;

    // When we launch this doggie ERC721 contract, it represents an entire collection of doggies.
    //And each doggie in the Doggie Basic nft collection is represented by a unique token ID.
    // Unique NFT = contract address which represents the collection + token ID
    constructor() ERC721("Dogie", "DOG") {
        s_tokenCounter = 0; // Everytime we mint a new Dogie NFT, we increment this counter. At the beginning, it's 0.
    }

    // Anybody can mint an nft and make it looks like whatever they want because they can specify the token URI.
    function mintNft(string memory tokenUri) public {
        s_tokenIdToUri[s_tokenCounter] = tokenUri; // We store the token URI in a mapping
        _safeMint(msg.sender, s_tokenCounter); // We mint the NFT to the sender of the transaction
        s_tokenCounter++;
    }

    // This function returns the token URI of a specific token ID.
    //It is not a transaction because it doesn't change the state of the blockchain.
    //
    // This URI point to a JSON that conforms to the ""ERC721 Metadata JSON Schema""
    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        return s_tokenIdToUri[tokenId];
        //return "ipfs://QmSsYRx3LpDAb1GZQm7zZ1AuHZjfbPkD6J7s9r41xu1mf8"; // This is the CID of your image file on IPFS. Upload it via ipfs desktop
        // View it on brave. This points to the IPFS network
    }
}
