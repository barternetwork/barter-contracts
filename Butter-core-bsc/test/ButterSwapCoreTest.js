
// fork testnet


const { baToJSON } = require("@nomicfoundation/ethereumjs-util");
const {expect} = require("chai");
const exp = require("constants");
const { sync } = require("glob");
const {ethers,network} = require("hardhat");
const { any } = require("hardhat/internal/core/params/argumentTypes");
const { formatUnits } =require('@ethersproject/units');



//// fork mainnet

describe("ButterswapRouterV1",function(){   
    let WHALE = '0x5096007EA5939A0948Bd89d9a48bccF8A94218e5';
    // let BNB = '0xae13d989daC2f0dEbFf460aC112a837C89BAa7cd';
    let BUSD ='0x78867BbEeF44f2326bF8DDd1941a4439382EF2A7';
    let ButterswapRouter;
    let owenr;
    let ButterRouter;
    let addre1;
    let addre2;
    let index = 0;
    let addrePancake;
    let whale;
    let busd;
    let bnb;
    // let ButterSwap;
   
    // eth - ERC20  pathArr[weth-erc20]
     // ERC20 - eth  pathArr[erc20-weth]
     
    beforeEach(async()=>{
    customHttpProvider  =   await network.provider.request({
        method: "hardhat_impersonateAccount",
        params: [WHALE]})  

        whale =  await ethers.getSigner(WHALE);

        // bnb = await ethers.getContractAt("IERC20",BNB);
        busd = await ethers.getContractAt("IERC20",BUSD);

       [owenr,addre1,addre2,addrePancake] = await ethers.getSigners();

        ButterswapRouter = await ethers.getContractFactory("ButterExchange");
        ButterRouter = await ButterswapRouter.deploy(owenr.address);
        await ButterRouter.deployed()
        ButterSwap = ButterRouter.address;
        console.log("ButterswapRouter address:",ButterRouter.address);


        const PancakeSwap = await ethers.getContractFactory("kernelPancakeSwapV2");
        const pancakeSwap = await PancakeSwap.deploy();
        await pancakeSwap.deployed()
        addrePancake = pancakeSwap.address
        console.log("pancakeSwap address:",addrePancake);


      

    });
     




      let _amountInArrs = 100n * 10n ** 18n;
        
      let _amountInArr = [_amountInArrs];
        // BNB-BUSD
    //let _paramsArr = ["0x0000000000000000000000000000000000000000000000000de0b6b3a76400000000000000000000000000000000000000000000000000000c7d713b49da000000000000000000000000000000000000000000000000000000000000000000e00000000000000000000000005096007ea5939a0948bd89d9a48bccf8a94218e50000000000000000000000000000000000000000000000000000000063abe5c7000000000000000000000000000000000000000000000000000000000000000000000000000000000000000078867bbeef44f2326bf8ddd1941a4439382ef2a70000000000000000000000000000000000000000000000000000000000000002000000000000000000000000ae13d989dac2f0debff460ac112a837c89baa7cd00000000000000000000000078867bbeef44f2326bf8ddd1941a4439382ef2a7"];
      
    // BUSD-BNB
     
      let  _paramsArr = ["0x0000000000000000000000000000000000000000000000056bc75e2d631000000000000000000000000000000000000000000000000000000c7d713b49da000000000000000000000000000000000000000000000000000000000000000000e00000000000000000000000005096007ea5939a0948bd89d9a48bccf8a94218e50000000000000000000000000000000000000000000000000000000063abe5c700000000000000000000000078867bbeef44f2326bf8ddd1941a4439382ef2a70000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000200000000000000000000000078867bbeef44f2326bf8ddd1941a4439382ef2a7000000000000000000000000ae13d989dac2f0debff460ac112a837c89baa7cd"];
      let _routerIndex = [0];

      let  _inputOutAddre = ["0x78867BbEeF44f2326bF8DDd1941a4439382EF2A7","0x0000000000000000000000000000000000000000"];


    let AccessParams = {
        amountInArr:_amountInArr,
        paramsArr:_paramsArr,
        routerIndex:_routerIndex,
        inputOutAddre:_inputOutAddre
    }


    it("Exchange of tokens",async ()=>{
        console.log(_amountInArr);
        let nwesRouter =  await ButterRouter.connect(owenr).setRouterAddreAll(index,addrePancake);
        console.log("---------111111--------");
        console.log(nwesRouter);


      
        let bal_busd =  await busd.balanceOf(whale.address);
        console.log("busd_balan:",bal_busd); 
        
        // Get the balance of an account
        console.log("BNB token:",await ethers.provider.getBalance(whale.address));
       

        await busd.connect(whale).approve(ButterRouter.address,_amountInArr[0]);
        console.log("approve");

        await ButterRouter.connect(whale).multiSwap(AccessParams);
        console.log("-------------11111-----------------");
 

        let bal_busd1 =  await busd.balanceOf(whale.address);
        console.log("busd_balan1:",bal_busd1); 

          // Get the balance of an account
          console.log("BNB token:",await ethers.provider.getBalance(whale.address));
     })

});