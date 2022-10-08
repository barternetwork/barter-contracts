
const {expect} = require("chai");
const exp = require("constants");
const { sync } = require("glob");
const {ethers,network} = require("hardhat");
const { any, string } = require("hardhat/internal/core/params/argumentTypes");
const { Bytecode } = require("hardhat/internal/hardhat-network/stack-traces/model");





describe("KernelUniSwapV3_test",function(){   
    let USDT_WHALE = '0x56Eddb7aa87536c09CCc2793473599fD21A8b17F';
    let USDT = '0xdAC17F958D2ee523a2206206994597C13D831ec7';
    let DAI = '0x6B175474E89094C44Da98b954EedeAC495271d0F';
    let whale;
    let usdt;
    let dai;
    let uniswap;
    
    
  
    
    beforeEach(async()=>{
        await network.provider.request({
        method: "hardhat_impersonateAccount",
        params: [USDT_WHALE]})    

        whale =  await ethers.getSigner(USDT_WHALE);
        usdt = await ethers.getContractAt("IERC20",USDT);
        dai = await ethers.getContractAt("IERC20",DAI);
        const uniswapV3 = await ethers.getContractFactory("kernelUniSwapV3_test");
        uniswap =  await uniswapV3.deploy()
    })
    
     
        
    

    // USDT -- USDC
    let  _amountInArrs = 10000000;
    let   _amountOutMinArrs = 150000000;
    let  _deadLines = new Date().getTime() + 999999;
    let  _pathArrs = '0xc2132D05D31c914a87C6611C10748AEb04B58e8F000bb86B175474E89094C44Da98b954EedeAC495271d0F';

    describe("fork uniswap mainnet",()=>{
    it("unlock caaount",async()=>{
        let bal_usdt =  await usdt.balanceOf(whale.address);
        console.log(bal_usdt); 
        console.log("------------111111111--------------------")

        //  const amount = 100n * 10n **6n;
        //  await usdt.connect(whale).transfer(uniswap.address,amount);

        //  balAddre2 = await usdt.balanceOf(whale.address);
        //  console.log(balAddre2);
        

        //  await usdt.connect(whale).approve(uniswap.address,_amountInArrs);
        // console.log("------------222222222--------------------")

        // let swap = '0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45';
        // let addre = await uniswap.getWeth(swap);
        // console.log(addre);

        // await  uniswap.connect(whale).filterSwap(_amountInArrs,_amountOutMinArrs,_pathArrs,whale.address,usdt.address,dai.address,{
        //     gasLimit: 30000000,
        //     gasPrice: 4407596212,
        //     });
        // console.log("------------333333333--------------------")

        // balAddre2 = await dai.balanceOf(whale.address);
        // console.log("balanceOf",balAddre2);
      })

    })


});