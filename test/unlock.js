
const {expect} = require("chai");
const { sync } = require("glob");
const {ethers,network} = require("hardhat");
const { any } = require("hardhat/internal/core/params/argumentTypes");



describe("Token",function(){
  
    let USDT_WHALE = '0x56Eddb7aa87536c09CCc2793473599fD21A8b17F';
    let USDT = '0xdAC17F958D2ee523a2206206994597C13D831ec7';
    let whale
    let usdt

    beforeEach(async()=>{
        await network.provider.request({
        method: "hardhat_impersonateAccount",
        params: [USDT_WHALE]})    

      whale =  await ethers.getSigner(USDT_WHALE);
      usdt = await ethers.getContractAt("IERC20",USDT);
    })


    describe("fork mainnet",()=>{
      it("unlock caaount",async()=>{

      let balAddre1 = await usdt.balanceOf(USDT_WHALE);
      console.log(balAddre1);
        
      // const amount = 100n * 10n **6n;
      // owen_Addre = '0x5C013338e5D0F84c81E66172Af09484BFBdfb71A';

      // balAddre2 = await usdt.balanceOf(owen_Addre);
      // console.log(balAddre2);

      // await usdt.connect(whale).transfer(owen_Addre,amount);
      
      // console.log(balAddre1);
      
      // balAddre2 = await usdt.balanceOf(owen_Addre);
      // console.log(balAddre2);

      })    
    })



});