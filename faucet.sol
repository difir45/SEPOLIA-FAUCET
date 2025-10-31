// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

contract SepoliaFaucet {
    mapping(address => uint256) private lastRequest;
    address public owner;
    uint256 public constant FAUCET_AMOUNT = 1 ether / 10;
    uint256 public constant COOLDOWN_PERIOD = 24 hours;
    
    event FaucetRequest(address indexed user, uint256 amount);
    event Recharged(address indexed by, uint256 amount);
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }
    
    constructor() {
        owner = msg.sender;
    }
    
    receive() external payable {
        emit Recharged(msg.sender, msg.value);
    }
    
    function requestSepoliaEth() external {
        require(block.timestamp >= lastRequest[msg.sender] + COOLDOWN_PERIOD, "Cooldown period has not passed yet.");
        require(address(this).balance >= FAUCET_AMOUNT, "Faucet is empty. Please try again later.");
        lastRequest[msg.sender] = block.timestamp;
        (bool success, ) = msg.sender.call{value: FAUCET_AMOUNT}("");
        require(success, "Failed to send Sepolia ETH.");
        emit FaucetRequest(msg.sender, FAUCET_AMOUNT);
    }
    
    function withdrawAll() external onlyOwner {
        uint256 balance = address(this).balance;
        (bool success, ) = payable(owner).call{value: balance}("");
        require(success, "Failed to withdraw funds.");
    }
    
    function getLastRequest(address _address) external view returns (uint256) {
        return lastRequest[_address];
    }
}
