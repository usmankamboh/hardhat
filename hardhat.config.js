require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();
// Ensure your configuration variables are set before executing the script
const { vars } = require("hardhat/config");

module.exports = {
  solidity: "0.8.26",
  paths: {
    sources: "./contracts",
  },
  networks: {
    sepolia: {
      url: "https://sepolia.infura.io/v3/afb592f5ab024052b4153217aa13d2a7",
      accounts: [process.env.SEPOLIA_PRIVATE_KEY],
    },
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  },
};
