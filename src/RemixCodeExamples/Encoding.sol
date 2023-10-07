// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Encoding {
    function combineStrings() public pure returns (string memory) {
        // abi.encodePacked return a bytes object
        return string(abi.encodePacked("Hi Mom! ", "Miss you!"));
    }

    // string.concat("Hi Mom! ", "Miss you!"); working for newer version of solidity

    // Any language that can compile down to the evm opCode -> This is known as the EVM, ethereum virtual machine
    // EVM basically represents all instructions a computer must be able to read for it to interact with ethereum or ethereum-like applications
    // This is why so many blockchains all work with solidity, because compiles down to to the evm opcode / bytecode (evm.codes)
    // BSC, ARB, POLYGON & AVAX, all compile down to the exact same type of binary and the exact same readers

    // abi.encodePacked: Non-standard way to encode stuffs.
    //It is pretty much encode anything we want to the binary format, which can be read using opcode

    function encodeNumber() public pure returns (bytes memory) {
        bytes memory number = abi.encode(1);
        // Encode number downs to its ABI (application binary interface) / its binary format (no actual binary version of it)
        // so that our contracts can interact with it in a way that the they understand
        // This is how the contract / computer is going to undetstand the number 1

        return number;
    }

    function encodeString() public pure returns (bytes memory) {
        bytes memory somestring = abi.encode("some string");
        return somestring;
        //0x0000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000b736f6d6520737472696e67000000000000000000000000000000000000000000
        // This is the exact low-level binary implementation for "some string"
        // A lots of zero for this perfect low-level binary, we can use encode packed
    }

    // EncodePacked is like a compressor. It the encode function but it compresses struffs
    function encodeStringPacked() public pure returns (bytes memory) {
        bytes memory somestring = abi.encodePacked(("some string"));
        return somestring;
        // This returns a much smaller bytes object. Save gas
        // 0x736f6d6520737472696e67
        // abi.encodePacked similar to type-casting
    }

    // The abi.encodePacked is copying the memory, the bytes() is just casting the pointer type.
    // casting a pointer type costs less than copying the memory.
    function encodeStringBytes() public pure returns (bytes memory) {
        bytes memory somestring = bytes("some string");
        return somestring;
        // 0x736f6d6520737472696e67
        // very similar to abi.encodePacked
    }

    // string(abi.encodePacked(string1, string2)):
    // 1 Combining 2 strings by using abi.encodePacked to encode them into their bytes implementation
    // 2 string() type casting them back from bytes to string
    // That's how the concatenation is done

    function decodeString() public pure returns (string memory) {
        // You have to specify what type of data do you want to decode the bytes to
        string memory somestring = abi.decode(encodeString(), (string)); // decode the encoded string (some string) ie bytes back to string format
        return somestring;
    }

    // We can actually multi encode and multi decode
    function multiEncode() public pure returns (bytes memory) {
        bytes memory somestring = abi.encode("some string", "it's bigger!");
        return somestring;
    }

    function multiDecode() public pure returns (string memory, string memory) {
        (string memory somestring, string memory someotherstring) = abi.decode(
            multiEncode(),
            (string, string)
        );
        return (somestring, someotherstring);
        //0:string: some string
        //1:string: it's bigger!
    }

    function multiEncodePacked() public pure returns (bytes memory) {
        bytes memory somestring = abi.encodePacked(
            "some string",
            "it's bigger!"
        );
        return somestring;
        // This is going to give us the packed version of these two string
        // abi.decode isn't going to work
    }

    function multiDecodePacked() public pure returns (string memory) {
        // abi.decode isn't going to work
        string memory somestring = abi.decode(multiEncodePacked(), (string));
        // This is a packed bytes and it is not working to decode this way
        return somestring;
    }

    function multiStringCastPacked() public pure returns (string memory) {
        string memory somestring = string(multiEncodePacked());
        return somestring;
        // // "some stringit's bigger!"
    }

    // To send a function,
    //1. ABI
    //2. Contract address
    // How do we send transaction that call functions with just the data field populated?
    // How do we populate the data field in a transaction

    // call: How we call functions to change the state of the blockchain
    // staticcall: This is how (at a low level) we do our "view" or "pure" function calls (no change in the state of blockchain, just give us the return value)

    function withdraw(address recentWinner) public {
        // interact with another contract (presumably, winner)
        // transfer the entire balance of the current contract (address(this).balance) to winner.
        (bool success, ) = recentWinner.call{value: address(this).balance}("");
        require(success, "Transfer failed");

        // Update the value of recentWinnder address in our transaction field (Where you put your money in the transaction)
        // You can also update GasPrice, GasLimit
        // (""); : This is where we are going to stick our Data, in a simple sending, Data field is empty
        // To send money: Change the value we are going to send, but don't pass any data, ie databit empty
    }

    // Remember this?
    // - In our {} we were able to pass specific fields of a transaction, like value.
    // - In our () we were able to pass data in order to call a specific function - but there was no function we wanted to call!
    // We only sent ETH, so we didn't need to call a function!
    // If we want to call a function, or send any data, we'd do it in these parenthesis!
}
