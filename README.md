# Swap mainnet Ether to Meta Pool mpETH token bridged to Linea L2

This repository contains a Solidity smart contract designed to function as a proxy for staking Ethereum. The contract does not hold any balances or tokens itself; instead, it operates by receiving native Ethereum and staking it in the Meta Pool, a liquid staking protocol, then bridge the assets `mpETH` to the **Linea** Ethereum Layer 2. Users receive mpETH tokens in return, which are redeemable for Ethereum. The staked Ethereum is deployed into 32 ETH validator nodes.

Users need to claim.

## Features

- **Receive Functionality**: Utilizes the `receive()` function in Solidity to accept native Ethereum.
- **Staking**: Automatically stakes received Ethereum in the Meta Pool.
- **mpETH Tokens**: Users receive mpETH tokens that can be redeemed for Ethereum.

## Prerequisites

- [Node.js](https://nodejs.org/en/) (v14.x or later)
- [npm](https://www.npmjs.com/) (v6.x or later)
- [Hardhat](https://hardhat.org/getting-started/) for running a local blockchain and testing.

## Installation

To set up the project locally, follow these steps:

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/ethereum-staking-proxy.git
   cd ethereum-staking-proxy
Install dependencies:

bash
Copy code
npm install
Compile the smart contracts:

bash
Copy code
npx hardhat compile
Usage
To deploy and interact with the contract, you can use Hardhat scripts or the Hardhat console:

Start a local blockchain:

bash
Copy code
npx hardhat node
Deploy the contracts:

bash
Copy code
npx hardhat run scripts/deploy.js --network localhost
Run tests:

bash
Copy code
npx hardhat test
Contributing
Contributions are welcome! Please follow these steps to contribute:

Fork the repository.
Create a new branch: git checkout -b your-branch-name.
Make changes and test.
Submit a Pull Request with comprehensive description of changes.
License
Distributed under the MIT License. See LICENSE for more information.

Contact
Your Name - Your Email

Project Link: https://github.com/your-username/ethereum-staking-proxy