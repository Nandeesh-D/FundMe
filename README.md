# FundMe

**FundMe** is a decentralized crowdfunding smart contract on the Ethereum blockchain. It allows users to contribute Ether (ETH) to support various projects or causes, ensuring that only the contract owner can withdraw the collected funds.

## Features

### 1. Fundraising
- Users can contribute ETH to the contract using the `fund()` function.
- Minimum contribution is set to **$5 USD** (converted to ETH using Chainlink's price feed).

### 2. Price Conversion
- Uses Chainlink's price feed oracle to convert ETH to USD.
- Ensures accurate minimum contributions based on real-time price data.

### 3. Withdrawals
- Only the contract owner can withdraw the collected funds.
- The contract resets contributors' balances and clears the list of funders after withdrawal.

### 4. Owner Verification
- The contract has a modifier `onlyOwner` to restrict certain functions (like `withdraw()`) to the contract owner.

### 5. Automatic Funding
- The contract includes `receive()` and `fallback()` functions to handle direct ETH transfers.

## Smart Contract Functions

- **fund()**: Allows users to contribute ETH, requiring a minimum of $5 USD.
- **withdraw()**: Allows the owner to withdraw all funds and reset funders' contributions.
- **getAmountFunded(address funder)**: Returns the amount of ETH funded by a specific address.
- **getFunder(uint256 index)**: Returns the address of a funder based on the index.
- **getOwner()**: Returns the address of the contract owner.
- **getPriceFeed()**: Returns the address of the Chainlink price feed oracle.

## Testing and Deployment

- The project includes testing and deployment using [Foundry]
- Ensure that the required environment variables and dependencies are correctly set up before running tests or deploying the contract.

## Setup

### Prerequisites
- Solidity `^0.8.19`
- Chainlink price feed for ETH/USD
- Foundry for testing and deployment
