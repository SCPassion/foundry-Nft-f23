// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Test} from "forge-std/Test.sol";
import {DeployBasicNft} from "../../script/DeployBasicNft.s.sol";
import {BasicNft} from "../../src/BasicNft.sol";

contract BasicNftTest is Test {
    DeployBasicNft public deployer;
    BasicNft public basicNft;
    address public USER = makeAddr("user");
    string public constant PUG =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/"; // This is the metadata of the pug image on IPFS

    // When you pin your file to IPFS locally, also pin it to another IPFS node
    function setUp() public {
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }

    function testNameIsCorrect() public view {
        string memory expectedName = "Dogie";
        string memory actualName = basicNft.name(); // This dogie name is stored in the ERC721 contract, defined in constructor
        // array of bytes -> Can't compare array to array
        // Compare only work with primitive types, ie. uint256, bool, address, byte32
        // for loop throught the array and compare the elements?
        // 2. use abi.encodePacked to pack the entire array and take the hash of it
        // A hash is a function that returns a fixed sized unique string that identifies the input

        // compare the hash instead of the array
        // step: Comvert a string to a bytes, then from a bytes to a bytes32, then hash it and compare the hash
        assert(
            keccak256(abi.encodePacked(expectedName)) == // keccak256 is a hash function, it takes a bytes and return a bytes32
                keccak256(abi.encodePacked(actualName)) // abi.encodePacked is a function that takes a string and return a bytes
        );
    }

    function testCanMintAndHaveABalance() public {
        vm.prank(USER);
        basicNft.mintNft(PUG);

        assert(basicNft.balanceOf(USER) == 1);
        assert(
            keccak256(abi.encodePacked(basicNft.tokenURI(0))) ==
                keccak256(abi.encodePacked(PUG))
        );
    }
}
