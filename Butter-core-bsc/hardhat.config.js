require("@nomicfoundation/hardhat-toolbox");



/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.17",

  networks:{
    hardhat:{
      forking:{
        enabled:true,
        chainid:97,
        // url:'https://data-seed-prebsc-2-s2.binance.org:8545'  
         url:'https://data-seed-prebsc-1-s1.binance.org:8545/'    
      },
    } 
  }
};


   // mainnet  url:'https://rpc.ankr.com/bsc