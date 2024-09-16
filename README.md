# Web3 Blockchain-Based Crowdfunding Platform [link](https://sparkling-crostata-b8a7f8.netlify.app/)

This project is a decentralized crowdfunding platform built on blockchain technology, designed to enable individuals and organizations to raise funds for their campaigns by a specified deadline. Utilizing Web3 technology and smart contracts, this platform provides a transparent, secure, and efficient method for raising capital, while eliminating intermediaries and enhancing user control.

## Features

- **Decentralized Fundraising**: Direct interaction between creators and backers, removing the need for third-party intermediaries.
- **Smart Contracts**: Automates fundraising processes, ensuring secure and transparent management of funds.
- **Campaign Deadlines**: Creators can set deadlines for their campaigns to motivate timely contributions.
- **Multi-Currency Support**: Contributions can be made using a variety of cryptocurrencies, increasing accessibility.
- **Immutable Ledger**: All transactions are recorded on the blockchain, providing a tamper-proof, transparent history.
- **Community Governance**: Decentralized decision-making enables the community to participate in platform governance.
- **Validation Mechanism**: Campaigns must be validated by registered validators to ensure legitimacy. Campaigns need a set number of validations to be considered active.
- **Validator Rewards**: Validators earn rewards in ether for each validation they perform, incentivizing them to participate in the platform's governance.
- **Prevention of Multiple Validations**: Validators are restricted from validating the same campaign more than once, ensuring fair participation.
- **User-Friendly Interface**: A seamless and intuitive user experience for both creators and backers.

## Tech Stack

- **Blockchain**: [Ethereum](https://ethereum.org/) or any compatible EVM-based blockchain
- **Smart Contracts**: [Solidity](https://soliditylang.org/) for smart contract development
- **Frontend**: [React.js](https://reactjs.org/) integrated with Web3.js or Ethers.js for blockchain interaction
- **Backend**: Decentralized storage or services such as [IPFS](https://ipfs.tech/) for storing campaign metadata
- **Wallet Integration**: MetaMask or other Web3 wallets for seamless user interaction

## Campaign Validation Mechanism

- **Validators**: Validators are participants who review and validate campaigns. Each validator is tracked by the number of campaigns they’ve validated and the rewards they've earned.
- **Validation Threshold**: Each campaign must be validated by at least two validators before it is marked as active. This ensures the legitimacy of campaigns before donations are accepted.
- **Reward System**: Validators are rewarded with 0.0001 ether per validation. This creates an incentive for validators to participate in ensuring the credibility of campaigns.
- **Validation Tracking**: Validators can only validate a campaign once, and all validations are securely recorded on the blockchain to ensure transparency and prevent fraud.
