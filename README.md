# BioWallet
A biometric smart wallet on iOS built using ERC 4337

# Web3 Functions
https://beta.app.gelato.network/ 
## template
https://github.com/gelatodigital/web3-functions-template

# BioWallet-contracts

See the first transactions on Goerli using Account Abstraction:
https://goerli.etherscan.io/address/0x9f26e38df18ba21bb369f3549f9a5f93887c8fc5#internaltx

BioWallet is an iOS app that allows users to secure their digital assets using facial recognition and nominees. It utilizes two key contracts, TrustedTxModifier and Identifier, to enhance security and functionality.

The TrustedTxModifier is a custom Safe modifier that allows an owner to execute transactions if an off-chain signature, verified through facial recognition, corresponds to the owner of the modifier. This enables BioWallet to execute transactions on behalf of users who have been verified through facial recognition.

The Identifier contract is a non-transferrable token that links users' digital wallets to their nominees. This allows users to recover their accounts by nominating trusted individuals who can vouch for their identity. The Identifier contract ensures that only the authorized nominees can access the user's account.

Together, these contracts provide a highly secure and user-friendly solution for managing digital assets on iOS devices. By leveraging facial recognition and nominees, BioWallet offers a simple yet powerful approach to account recovery and transaction authorization.

# Deploy backend 

## Compile contracts 
npx hardhat compile

## Test network
npx hardhat node

## Get public key
node getpublickey.js
0x037e21d08dd8022967445b65cdc77dc576e4056bcd00a7b96a07cd83e38f170604

## Get testnet gas
https://faucet.polygon.technology/ 
https://calibration-faucet.filswan.com/#/dashboard 

## Deploy contracts
write a .env file with MNEMONIC and INFURA_API_KEY

## Mainnet
npx hardhat run scripts/deploy.ts --network matic

## Testnet
npx hardhat run scripts/deploy.ts --network mumbai

Output: 
creates: '0x27466E63408Ed8e79737cf0809691D03b039294A',

## Check deployment success
https://mumbai.polygonscan.com/address/0x27466E63408Ed8e79737cf0809691D03b039294A

## Test 
npx hardhat test
