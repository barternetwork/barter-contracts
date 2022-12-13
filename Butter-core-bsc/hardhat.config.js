require("@nomicfoundation/hardhat-toolbox");



/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.17",

  networks:{
    hardhat:{
      forking:{
        enabled:true,
        chainid:97,
        url:'https://bsctestapi.terminet.io/rpc'      
      },
    } 
  }
};


   // mainnet  url:'https://rpc.ankr.com/bsc