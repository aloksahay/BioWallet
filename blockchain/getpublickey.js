const ethers = require('ethers');

require("dotenv").config();

const { MNEMONIC, INFURA_API_KEY, MATIC_VIGIL_API_KEY } = process.env;

// replace with your own mnemonic
const mnemonic = MNEMONIC;

// create a new wallet instance from the mnemonic
const wallet = ethers.Wallet.fromMnemonic(mnemonic);

// get the public key from the wallet
const publicKey = wallet.publicKey;

console.log(publicKey);

const compressedPublicKey = ethers.utils.computePublicKey(wallet.privateKey, compressed=true);

console.log(compressedPublicKey);

// compute the Ethereum address from the compressed public key
const address = ethers.utils.computeAddress(compressedPublicKey);

console.log(address);

