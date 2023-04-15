import { HardhatUserConfig } from "hardhat/config";

require("@nomiclabs/hardhat-etherscan");
require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
require("@nomiclabs/hardhat-vyper");

import "@nomiclabs/hardhat-etherscan";
require("dotenv").config();

const { MNEMONIC, INFURA_API_KEY, MATIC_VIGIL_API_KEY } = process.env;

const config: HardhatUserConfig = {
  solidity: "0.8.16",
  vyper: {
    version: "0.3.6",
  },
  networks: {
    mumbai: {
      url: `https://rpc-mumbai.maticvigil.com/v1/${MATIC_VIGIL_API_KEY}`,
      chainId: 80001,
      accounts: {
        mnemonic: MNEMONIC,
      },
    },
  },
  etherscan: {
    apiKey: process.env.POLYGONSCAN_API_KEY,
  },
  // Enable hardhat-deploy plugin
  // And make sure it comes AFTER the other plugins
  // to have access to their deployments
  plugins: ["@nomiclabs/hardhat-ethers", "@nomiclabs/hardhat-vyper", "hardhat-deploy"],

};

export default config;
