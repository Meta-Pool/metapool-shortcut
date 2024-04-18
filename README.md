# Swap mainnet Ether to Meta Pool mpETH token bridged to Linea L2

<img src="./media/linea.png" width="500" height="250">

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

## Claim

```sol
/**
   * @notice Claims and delivers a cross-chain message.
   * @dev _feeRecipient Can be set to address(0) to receive as msg.sender.
   * @dev messageSender Is set temporarily when claiming and reset post.
   * @param _from The address of the original sender.
   * @param _to The address the message is intended for.
   * @param _fee The fee being paid for the message delivery.
   * @param _value The value to be transferred to the destination address.
   * @param _feeRecipient The recipient for the fee.
   * @param _calldata The calldata to pass to the recipient.
   * @param _nonce The unique auto generated message number used when sending the message.
   */
  function claimMessage(
    address _from,
    address _to,
    uint256 _fee,
    uint256 _value,
    address payable _feeRecipient,
    bytes calldata _calldata,
    uint256 _nonce
  ) external
```

Status
1 - call inboxL1L2MessageStatus

0 - No mssg
1 - message arrived
2 - message claimed

messageHash
by-bridge: 0xe062ef59821418a74bfaa407a3ba480a9324020f67aa8c9b8e5e911f1bafe338
by-swap: 0x9861ceadb94d0357ffd2622899786e6976d9c5fe89072d62c1865a0f5ec3600c
https://sepolia.lineascan.build/address/0x971e727e956690b9957be6d51Ec16E73AcAC83A7#readProxyContract

Claim
2 claimMessage(address _from,address _to,uint256 _fee,uint256 _value,address _feeRecipient,bytes _calldata,uint256 _nonce)

```
0	_from	address	0x5A0a48389BB0f12E5e017116c1105da97E129142
1	_to	address	0x93DcAdf238932e6e6a85852caC89cBd71798F463
2	_fee	uint256	0
3	_value	uint256	0
4	_feeRecipient	address	0x0000000000000000000000000000000000000000
5	_calldata	bytes	0xe4d27451000000000000000000000000b9860e8552f14dc81ba08f2251d88179faf81ef50000000000000000000000000000000000000000000000000186cc6acd4b00000000000000000000000000000b438de1dca9fba6d14f17c1f0969ecc73c8186f0000000000000000000000000000000000000000000000000000000000aa36a700000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000e0000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000000000000000000000000012000000000000000000000000000000000000000000000000000000000000000d4d65746120506f6f6c204554480000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000076d70455448303100000000000000000000000000000000000000000000000000
6	_nonce	uint256	1323
```

claim by-swap

_from: (eventLog: MessageSent _from): 0x5A0a48389BB0f12E5e017116c1105da97E129142

_to (eventLog: MessageSent _to): 0x93DcAdf238932e6e6a85852caC89cBd71798F463

(ALL ZERO)
_fee	uint256	0
_value	uint256	0
_feeRecipient	address	0x0000000000000000000000000000000000000000

_calldata (eventLog: MessageSent _calldata): E4D27451000000000000000000000000B9860E8552F14DC81BA08F2251D88179FAF81EF500000000000000000000000000000000000000000000000001A97915E24D00000000000000000000000000000B438DE1DCA9FBA6D14F17C1F0969ECC73C8186F0000000000000000000000000000000000000000000000000000000000AA36A700000000000000000000000000000000000000000000000000000000000000A000000000000000000000000000000000000000000000000000000000000000E0000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000000A00000000000000000000000000000000000000000000000000000000000000012000000000000000000000000000000000000000000000000000000000000000D4D65746120506F6F6C204554480000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000076D70455448303100000000000000000000000000000000000000000000000000

_nonce (eventLog MessageSent _nonce): 1324
```