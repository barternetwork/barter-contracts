require("@nomicfoundation/hardhat-toolbox");


// hardhat config

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.17",

  networks:{
    hardhat:{
      forking:{
        enabled:true,
        chainid:80001,
        url:'https://polygon-mumbai.g.alchemy.com/v2/nHUrz_XE7z7mrNnKhZJHYT9-gDjaUxeB'      
      },
    } 
  }
};


   // mainnet  url:'https://rpc.ankr.com/bsc