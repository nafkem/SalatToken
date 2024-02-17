require('@nomicfoundation/hardhat-toolbox');
require("dotenv").config({ path: ".env" });

module.exports = {
  solidity: "0.8.24",
  networks: {
    mumbai: {
      url: process.env.EVM_RPC,
      accounts: [process.env.PRIVATEKEY],
    },
  },
  }
