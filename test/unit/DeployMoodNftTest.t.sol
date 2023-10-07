// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {Test, console} from "forge-std/Test.sol";
import {DeployMoodNft} from "../../script/DeployMoodNft.s.sol";

contract DeployMoodNftTest is Test {
    DeployMoodNft public deployer;

    function setUp() public {
        deployer = new DeployMoodNft();
    }

    function testConvertSvgToUri() public view {
        // Use https://www.base64encode.org/ to encode the svg to base64 and store it in expectedURI. The problem is: when you save your svg, the format changes a bit then the base64 change accordingly.
        string
            memory expectedURI = "data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHdpZHRoPSI1MDAiIGhlaWdodD0iNTAwIj48dGV4dCB4PSIwIiB5PSIxNSIgZmlsbD0iYmxhY2siPiBoaSEgWW91IGRlY29kZWQgdGhpcyE8L3RleHQ+PC9zdmc+";
        // Single '' is used for svg. This is the svg file content without spaces in between. This svg content should also go to the website before the generate the expected URI.
        string
            memory svg = '<svg xmlns="http://www.w3.org/2000/svg" width="500" height="500"><text x="0" y="15" fill="black"> hi! You decoded this!</text></svg>';
        string memory actualURI = deployer.svgToImageURI(svg);

        assert(
            keccak256(abi.encodePacked(actualURI)) ==
                keccak256(abi.encodePacked(expectedURI))
        );
    }
}
