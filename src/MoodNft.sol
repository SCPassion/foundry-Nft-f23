// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721 {
    // Errors
    error MoodNft__CantFlipMoodIfNotOwner();

    uint256 private s_tokenCounter;
    string private s_sadSvgImageUri;
    string private s_happySvgImageUri;

    enum Mood {
        HAPPY,
        SAD
    }

    mapping(uint256 => Mood) private s_tokenIdToMood;

    // take the happy.svg and sad.svg base64 encode Image Uri to the constructor
    // Image Uri is not the token Uri. The tokenUri is the metadata of the NFT.
    // TOkenRUi is a JSON that conforms to the ERC721 Metadata JSON Schema
    constructor(
        string memory sadSvgImageUri,
        string memory happySvgImageUri
    ) ERC721("Mood NFT", "MN") {
        s_tokenCounter = 0;
        s_sadSvgImageUri = sadSvgImageUri;
        s_happySvgImageUri = happySvgImageUri;
    }

    function mintNft() public {
        _safeMint(msg.sender, s_tokenCounter);
        // When an NFT is mintedm default the mood to happy
        s_tokenIdToMood[s_tokenCounter] = Mood.HAPPY;
        s_tokenCounter++;
    }

    function flipMood(uint256 tokenId) public {
        // only want the NFT owner to be able to change the mood
        if (!_isApprovedOrOwner(msg.sender, tokenId)) {
            revert MoodNft__CantFlipMoodIfNotOwner();
        }

        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            s_tokenIdToMood[tokenId] = Mood.SAD;
        } else {
            s_tokenIdToMood[tokenId] = Mood.HAPPY;
        }
    }

    // This return the baseURI of our metadata
    function _baseURI() internal pure override returns (string memory) {
        // data:image/svg+xml;base64, Since we are not working with image but with json, we need to change the prefix
        return "data:application/json;base64,";
    }

    // Define what the Nft will look like
    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        string memory imageURI;
        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            imageURI = s_happySvgImageUri;
        } else {
            imageURI = s_sadSvgImageUri;
        }

        // How do we store the metadata of the NFT on chain?
        // Encode json in base64 like we do with svg in the terminal with eg. base64 -i happy.svg

        // string.concat('{"name": "', name(), '"}'); =  {"name": "Mood NFT"}
        // A base64 is string that is encoded in a way that is safe to be passed in a URL

        // First create the json object and conver it to a json tokenURI
        return
            // wrap this whole thing back in a string
            string(
                // We concatenate the baseURI string with the json bas64 string.
                // This gives us the whole URI to access the metamdata of the NFT
                // Combined together, we can post to the browser URI
                abi.encodePacked(
                    // We add the _baseURI() to the front of base64 json string.
                    _baseURI(),
                    // This Base64.encode returns a base64 encoded string of the json object, combined with the beginning baseURI.
                    // Now This is equavalent to us calling similar function like base64 -i jsonName in the terminal
                    Base64.encode(
                        // Convert the json object to bytes in order to use openzeppelin Base64 library
                        bytes(
                            // Create our json object here onchain, and use abi.encodePacked to concatenate the whole string together
                            abi.encodePacked(
                                '{"name": "',
                                name(),
                                '", "description": "An NFT that reflects the owners mood.", "attribute":[{"trait_type":"moodiness"}, {"value": "100"}], "image": "',
                                imageURI,
                                '"}'
                            )
                        )
                    )
                )
            );
    }
}
