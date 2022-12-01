
const {expect} = require("chai");
const exp = require("constants");
const { sync } = require("glob");
const {ethers,network} = require("hardhat");
const { any } = require("hardhat/internal/core/params/argumentTypes");



describe("kernelSushiSwapV2_test",function(){   
    let USDT_WHALE = '0x56Eddb7aa87536c09CCc2793473599fD21A8b17F';
    let USDT = '0xdAC17F958D2ee523a2206206994597C13D831ec7';
    let USDC ='0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48';
    let whale;
    let usdt;
    let usdc;
    let sushiSwap
  

    beforeEach(async()=>{
        await network.provider.request({
        method: "hardhat_impersonateAccount",
        params: [USDT_WHALE]})    

        whale =  await ethers.getSigner(USDT_WHALE);
        usdt = await ethers.getContractAt("IERC20",USDT);
        usdc = await ethers.getContractAt("IERC20",USDC);
        const SushiSwap = await ethers.getContractFactory("SushiSwapV2_Test");
        sushiSwap =  await SushiSwap.deploy()
    })
 
    // USDT -- USDC
    let  _amountInArrs = 10000000;
    let   _amountOutMinArrs = 0;
    let  _deadLines = new Date().getTime() + 999999;
    const abi = ethers.utils.defaultAbiCoder;
    let  _pathArrs = '0x00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000002000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec7000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb48';
    let  _msgaddre = "0x923c32E239D4Cb04e242904D5f13Da75a6e00641";
    describe("fork sushi mainnet",()=>{
    it("unlock caaount",async()=>{
        let bal_usdt =  await usdt.balanceOf(whale.address);
        console.log(bal_usdt); 
        console.log("------------111111111--------------------")


        let balan_usdc1 = await usdc.balanceOf(whale.address);
        console.log("balanceOf1:",balan_usdc1);
      
         await usdt.connect(whale).approve(sushiSwap.address,_amountInArrs);
        console.log("------------222222222--------------------")

        await  sushiSwap.connect(whale).filterSwap(_amountInArrs,_amountOutMinArrs,_pathArrs,whale.address,_deadLines,usdt.address,usdc.address);
        console.log("------------333333333--------------------")

        let balAddre2 = await usdc.balanceOf(whale.address);
        console.log("balanceOf:",balAddre2);

        let bala_usdt1 = await usdt.balanceOf(whale.address);
        console.log("balanceOf:",bala_usdt1);
      })

    })


});