// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title SepoliaFaucet
 * @notice A simple faucet contract for Sepolia ETH with a 24-hour cooldown per user.
 * The contract can be recharged by anyone.
 * The mainnet balance check is handled off-chain by the frontend.
 */
contract SepoliaFaucet {

    // A mapping to store the last timestamp a user made a request.
    mapping(address => uint256) private lastRequest;

    // The owner of the contract.
    address public owner;

    // The amount of Sepolia ETH to be sent with each request (0.1 ETH).
    uint256 public constant FAUCET_AMOUNT = 1 ether / 10; // 0.1 ETH

    // The cooldown period in seconds (24 hours).
    uint256 public constant COOLDOWN_PERIOD = 24 hours;

    // An event to log successful faucet requests.
    event FaucetRequest(address indexed user, uint256 amount);

    // An event to log when the contract is recharged.
    event Recharged(address indexed by, uint256 amount);

    /**
     * @dev Modifier to restrict function access to the contract owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function.");
        _;
    }

    /**
     * @dev The constructor sets the owner to the address that deploys the contract.
     */
    constructor() {
        owner = msg.sender;
    }

    /**
     * @notice Allows anyone to send Sepolia ETH to the contract.
     * This function is payable, so it can receive ETH.
     */
    receive() external payable {
        emit Recharged(msg.sender, msg.value);
    }

    /**
     * @notice Allows a user to request 0.1 Sepolia ETH.
     * @dev The function checks for a 24-hour cooldown period.
     * The mainnet balance check is performed by the frontend.
     */
    function requestSepoliaEth() external {
        // Ensure the cooldown period has passed since the last request.
        require(block.timestamp >= lastRequest[msg.sender] + COOLDOWN_PERIOD, "Cooldown period has not passed yet.");

        // Ensure the contract has enough funds to fulfill the request.
        require(address(this).balance >= FAUCET_AMOUNT, "Faucet is empty. Please try again later.");

        // Update the last request time for the user.
        lastRequest[msg.sender] = block.timestamp;

        // Send the Sepolia ETH to the caller.
        (bool success, ) = msg.sender.call{value: FAUCET_AMOUNT}("");
        require(success, "Failed to send Sepolia ETH.");

        emit FaucetRequest(msg.sender, FAUCET_AMOUNT);
    }

    /**
     * @notice Allows the owner to withdraw all Sepolia ETH from the contract.
     */
    function withdrawAll() external onlyOwner {
        // Get the contract's current balance.
        uint256 balance = address(this).balance;

        // Send the entire balance to the owner's address.
        (bool success, ) = payable(owner).call{value: balance}("");
        require(success, "Failed to withdraw funds.");
    }

    /**
     * @notice Returns the timestamp of the last request for a given address.
     * @param _address The address to check.
     * @return The last request timestamp.
     */
    function getLastRequest(address _address) external view returns (uint256) {
        return lastRequest[_address];
    }
}

