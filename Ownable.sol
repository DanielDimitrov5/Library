// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

error Ownable__NotInvokdeByTheOwner();

contract Ownable {
    address public owner;
    
    modifier onlyOwner() {
        if (owner != msg.sender) revert Ownable__NotInvokdeByTheOwner();
        _;
    }
    
    constructor() {
        owner = msg.sender;
    }
}