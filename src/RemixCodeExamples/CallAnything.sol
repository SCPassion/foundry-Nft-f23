// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// In order to call a function using only the data field of call, we need to encode:
// 1. The function name
// 2. The parameters we want to add
// 3. Down the these 2 above to the binary level, so that evm / ethereum based smart contract can understand what's going on

// To encode the function name, we need "function selector": the first 4 bytes of the function signature

// "function signature": a string that defines the function name & parameters
// Example Function Signature: "transfer(address,uint256)"
// vvvvv
// If we encode this "transfer(address,uint256)", and take the first 4 bytes of it, we get the function selector:
// vvvvv
// Example Function Selector: 0xa9059cbb

// That's how solidity, in the binary / bytes code,
// this function selector is how solidity knows, which function the transaction is talking about
// ie. This transaction is about the transfer, this transaction needs to call "transfer(address,uint256)"

// This is one of the first things that we need to use call to call any function that we want

contract CallAnything {
    address public s_someAddresses;
    uint256 public s_amount;

    // Function signature "transfer(address,uint256)"
    function transfer(address someAddress, uint256 amount) public {
        s_someAddresses = someAddress;
        s_amount = amount;
    }

    function getSelectorOne() public pure returns (bytes4 selector) {
        selector = bytes4(keccak256(bytes("transfer(address,uint256)")));
        // 0xa9059cbb
        // This tells our smart contract that this bytes4 is refering to our transfer function
    }

    // This is going to give us all data that we need to put in that datafield of our transaction to send to this contract
    // let this contract knows: Use the transfer function and pass in (someAddress, amount)
    function getDataToCallTransfer(
        address someAddress,
        uint256 amount
    ) public pure returns (bytes memory) {
        return abi.encodeWithSelector(getSelectorOne(), someAddress, amount);
        // 0xa9059cbb0000000000000000000000005e17b14add6c386305a32928f985b29bba34eff50000000000000000000000000000000000000000000000000000000000000309
        // This is what we are going to put into the datafield of our transaction in order for us to call transfer from anywhere
        // i.e. the binary encoded of : Call the transfer with our specific address, and a certain amount
    }

    // With this, we can call our transfer function without directly call it
    function callTransferFunctionWithBinary(
        address someAddress,
        uint256 amount
    ) public returns (bytes4, bool) {
        // Transfer to address address(this)
        // returnData: whatever the call return
        // If you want ot call the function to another contract, Address2.call();
        (bool success, bytes memory returnData) = address(this).call(
            abi.encodeWithSelector(getSelectorOne(), someAddress, amount)
        );

        // Call the transfer function by passing some parameters without us calling directly transfer()
        return (bytes4(returnData), success);
    }

    // Another way to call it. It did bytes4(keccak256(bytes("transfer(address,uint256)"))) for us
    function callTransferFunctionWithBinarySignature(
        address someAddress,
        uint256 amount
    ) public returns (bytes4, bool) {
        // Turn the function sigurature into the selector for us
        (bool success, bytes memory returnData) = address(this).call(
            abi.encodeWithSignature(
                "transfer(address,uint256)",
                someAddress,
                amount
            )
        );
        return (bytes4(returnData), success);
    }

    // A bunch of different ways to get selector
}
