
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
    let  _exchangeData = '0x0000000000000000000000000000000000000000000000000000000000989680000000000000000000000000000000000000000000000000000000000089544000000000000000000000000000000000000000000000000000000000000000e000000000000000000000000056eddb7aa87536c09ccc2793473599fd21a8b17f0000000000000000000000000000000000000000000000000000000063abe5c7000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec7000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb480000000000000000000000000000000000000000000000000000000000000002000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec7000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb48';
    let   _amountinArrs = 10n * 10n ** 6n;
    // let  _deadLines = new Date().getTime() + 999999;
    // const abi = ethers.utils.defaultAbiCoder;
    // let  _pathArrs = '0x00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000002000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec7000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb48';
    // let  _msgaddre = "0x923c32E239D4Cb04e242904D5f13Da75a6e00641";

   
    describe("fork sushi mainnet",()=>{
    it("unlock caaount",async()=>{
        let bal_usdt =  await usdt.balanceOf(whale.address);
        console.log("usdt_balan",bal_usdt); 
        console.log("------------111111111--------------------")


        let balan_usdc = await usdc.balanceOf(whale.address);
        console.log("usdc_balan:",balan_usdc);
        console.log("------------222222222--------------------")


         await usdt.connect(whale).approve(sushiSwap.address,_amountinArrs);
        console.log("------------approve usdt--------------------")

        await  sushiSwap.connect(whale).filterSwap(_exchangeData);
        console.log("------------333333333--------------------")

        let balan_usdt = await usdt.balanceOf(whale.address);
        console.log("balanceOf:",balan_usdt);
        console.log("------------4444444444--------------------")

        let bala_usdc = await usdc.balanceOf(whale.address);
        console.log("balanceOf:",bala_usdc);
        console.log("------------5555555555--------------------")
      })

    })


});