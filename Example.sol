// SPDX-License-Identifier: " to each source file. Use "SPDX-License-Identifier: UNLICENSED" for non-open-source code. Please see https://spdx.org for more information.
pragma solidity ^0.7.6;

contract Example {

    uint256 value;
    string uniqueKey = "";
    address buyer;
    address seller;

    event LogErrorString(string message);

    constructor (string memory uniqueKeyParam, address _buyer, address _seller) {
        uniqueKey = uniqueKeyParam;
        buyer = _buyer;
        seller = _seller;
    }

    modifier onlyBuyer() {
        require(msg.sender == buyer, "Only buyer can call this method");
        _;
    }
    
    modifier onlySeller() {
        require(msg.sender == seller, "Only buyer can call this method");
        _;
    }

    // Responsible for verifying that the passed secret key is good
    function IsSecretKeyGood(string memory matchUniqueKeyParam)view public returns (bool){
        // basic validaion - secret key is already set
        require (keccak256(abi.encodePacked(uniqueKey)) != keccak256(abi.encodePacked("")), "Secret key is not yet set");
        require (keccak256(abi.encodePacked(matchUniqueKeyParam)) != keccak256(abi.encodePacked("")), "Secret key is missing");
        // check with the set secret key
        require(keccak256(abi.encodePacked(uniqueKey)) == keccak256(abi.encodePacked(matchUniqueKeyParam)), "The secret code does not match!");

        return true;
    }

    function SellerCall() view public onlySeller returns (bool){
        return true;
    }

    function BuyerCall() view public onlyBuyer returns (bool){
        return true;
    }

    // function setPublicKey(string memory uniqueKeyParam) public{
    //     uniqueKey = uniqueKeyParam;
    // }

    //   function validateSecretCode(string memory codeA, string memory codeB) private returns (bool isEqual)
    // {
    //     if (keccak256(abi.encodePacked(codeA)) == keccak256(abi.encodePacked(codeB))) {
    //         return false;
    //     }

    //     return true;
    // }

    // function getStr() view public returns (string memory) {
    //     return str;
    // }

    // function setP(uint256 _n) payable public {
    //     value = value - _n;
    // }

    // function setNP(uint256 _n) public {
    //     value = _n;
    // }

    // function get () view public returns (uint256) {             
    //     return value;
    // }
}
