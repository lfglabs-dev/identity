# StarknetId Identity Contract

This contract allows for the free minting of ERC721 tokens that can hold data written by either a user or any external contract (called a verifier contract). This provides a flexible system for managing identities on Starknet. Below are the key features and technical details of this contract.

## Features

- **Free Minting**: Users can freely mint ERC721 tokens at no cost, and this can be done by anyone permissionlessly.
- **Multicall Compatible**: The minting process is compatible with multicall, allowing users to specify the ID to use before minting.
- **Data Storage**: The tokens can hold data written by the user or an external verifier contract.
- **Flexible Data Writing**: There are no restrictions on what data can be written on the identities. Data can be in the form of one or multiple felts, with one mapping for user data and one for each verifier contract.

## Ecosystem Support

While you can theoretically write any kind of data on any data field, the ecosystem already supports some standards, including:
- **Profile Pictures**: Supported by the [NFT Profile Picture Verifier](https://github.com/starknet-id/nft_pp_verifier) contract.
- **GitHub, Discord, and Twitter IDs**: Supported by the [Social Verifier](https://github.com/starknet-id/verifier) contract.
- **EVM Addresses**: Set directly by the user.

## Audits

For additional trust and transparency, this contract has been audited by independent third-party security firms. You can view the audit reports below:

- [Cairo Security Clan Audit](./audits/cairo_security_clan.pdf)
- [Subsix Audit](./audits/subsix.pdf)

## How to Build/Test?

This project was built using Scarb.

### Building

To build the project, run the following command:

```
scarb --release build
```

### Testing

To run the tests, use the following command:

```
scarb test
```

For more information and to explore the Starknet Naming System, which builds on top of these identity NFTs, visit the [StarknetID Naming Repository](https://github.com/starknet-id/naming).
