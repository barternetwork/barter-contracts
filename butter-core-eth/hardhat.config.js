require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */


const ALCHEMY_API_KEY = "b485390c222144b589fb5e6707a0e88a";




module.exports = {
  solidity: "0.8.17",
  networks:{
    hardhat:{
      forking:{
        enabled:true,
        url:'https://eth-mainnet.g.alchemy.com/v2/Gal5TfQIimFXW6D8plIco17HxVzch5_M'
      },
    },
    ganache:{
      url:'http://127.0.0.1:8545'
    },
    Ropsten:{
      url :'https://ropsten.infura.io/v3/' + ALCHEMY_API_KEY,
      accounts:['0x438e472724961ae8a56e2247bebe921dc4e3437eecb6e15f9277871dfdb69383'],
    },
    bsctest:{
      url:'https://data-seed-prebsc-1-s1.binance.org:8545/',
      accounts:['0x438e472724961ae8a56e2247bebe921dc4e3437eecb6e15f9277871dfdb69383']
    }
  }
};
