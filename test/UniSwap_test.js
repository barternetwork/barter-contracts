
const {expect} = require("chai");
const exp = require("constants");
const { sync } = require("glob");
const {ethers,network} = require("hardhat");
const { any, string } = require("hardhat/internal/core/params/argumentTypes");
const { Bytecode } = require("hardhat/internal/hardhat-network/stack-traces/model");





describe("KernelUniSwapV3_test",function(){   
    let USDT_WHALE = '0x56Eddb7aa87536c09CCc2793473599fD21A8b17F';
    let USDT = '0xdAC17F958D2ee523a2206206994597C13D831ec7';
    let USDC = '0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48';
    let whale;
    let usdt;
    let usdc;
    let uniswap;
    
    
  
    
    beforeEach(async()=>{
        await network.provider.request({
        method: "hardhat_impersonateAccount",
        params: [USDT_WHALE]})    

        whale =  await ethers.getSigner(USDT_WHALE);
        usdt = await ethers.getContractAt("IERC20",USDT);
        usdc = await ethers.getContractAt("IERC20",USDC);
        const uniswapV3 = await ethers.getContractFactory("UniSwapV3_Test");
        uniswap =  await uniswapV3.deploy()
    })
    
     
        
    

    // USDT -- USDC
    let _amountInArr =  10n * 10n **6n;

    let _amountOutMinArr = 9n * 10n **6n;
    
    let  _pathArrs = '0xdAC17F958D2ee523a2206206994597C13D831ec7000bb8A0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48';

    describe("fork uniswap mainnet",()=>{
    it("unlock caaount",async()=>{


        let bal_usdt =  await usdt.balanceOf(whale.address);
        console.log(bal_usdt); 
        console.log("------------111111111--------------------")

         let bal_usdc = await usdc.balanceOf(whale.address);
         console.log(bal_usdc);
        

         await usdt.connect(whale).approve(uniswap.address,_amountInArr);
        console.log("------------222222222--------------------")



        await  uniswap.connect(whale).filterSwap(_amountInArr,_amountOutMinArr,_pathArrs,whale.address,usdt.address,usdc.address);
        console.log("------------ swap Success --------------------")

        let balan_usdc1 = await usdc.balanceOf(whale.address);
        console.log(balan_usdc1);
      })

    })


});