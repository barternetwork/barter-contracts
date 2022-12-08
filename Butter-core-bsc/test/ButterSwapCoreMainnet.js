
const { baToJSON } = require("@nomicfoundation/ethereumjs-util");
const {expect} = require("chai");
const exp = require("constants");
const { sync } = require("glob");
const {ethers,network} = require("hardhat");
const { any } = require("hardhat/internal/core/params/argumentTypes");




//// fork mainnet

describe("ButterswapRouterV1",function(){   
    let WHALE = '0x5B83802bF19832e76b98DDf4fC775357562aDe2D';
    let WBNB = '0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c';
    let USDC ='0x8AC76a51cc950d9822D68b83fE1Ad97B32Cd580d';
    let ButterswapRouter;
    let owenr;
    let ButterRouter;
    let addre1;
    let addre2;
    let index = 0;
    let addrePancake;
    let whale;
    let usdc;
    let wbnb;
    // let ButterSwap;


    beforeEach(async()=>{
        await network.provider.request({
        method: "hardhat_impersonateAccount",
        params: [WHALE]})    
        whale =  await ethers.getSigner(WHALE);

        wbnb = await ethers.getContractAt("IERC20",WBNB);
        usdc = await ethers.getContractAt("IERC20",USDC);

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
     




      let _amountInArrs = 10n * 10n ** 18n;

      let _amountInArr = [_amountInArrs];

      let _paramsArr = ["0x0000000000000000000000000000000000000000000000008ac7230489e800000000000000000000000000000000000000000000000000007ce66c50e284000000000000000000000000000000000000000000000000000000000000000000e00000000000000000000000005b83802bf19832e76b98ddf4fc775357562ade2d0000000000000000000000000000000000000000000000000000000063abe5c7000000000000000000000000bb4cdb9cbd36b01bd1cbaebf2de08d9173bc095c0000000000000000000000008ac76a51cc950d9822d68b83fe1ad97b32cd580d0000000000000000000000000000000000000000000000000000000000000002000000000000000000000000bb4cdb9cbd36b01bd1cbaebf2de08d9173bc095c0000000000000000000000008ac76a51cc950d9822d68b83fe1ad97b32cd580d"];
      
      let _routerIndex = [0];

      let  _inputOutAddre = ["0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c","0x8AC76a51cc950d9822D68b83fE1Ad97B32Cd580d"];


    let AccessParams = {
        amountInArr:_amountInArr,
        paramsArr:_paramsArr,
        routerIndex:_routerIndex,
        inputOutAddre:_inputOutAddre
    }


    it("Exchange of tokens",async ()=>{
        
        let nwesRouter =  await ButterRouter.connect(owenr).setRouterAddreAll(index,addrePancake);
        console.log("---------111111--------");
        console.log(nwesRouter);


        let bal_wbnb =  await wbnb.balanceOf(whale.address);
        console.log("wbnb_balan:",bal_wbnb); 

        let bal_usdc =  await usdc.balanceOf(whale.address);
        console.log("usdc_balan:",bal_usdc); 


        await wbnb.connect(whale).approve(ButterRouter.address,_amountInArr[0]);


        console.log(addrePancake);
        console.log("------------222222--------------------")
        await ButterRouter.connect(whale).multiSwap(AccessParams);

        let wbnb_balan1 =  await wbnb.balanceOf(whale.address);
        console.log("wbnb_balan:",wbnb_balan1); 

        let bal_usdc1 =  await usdc.balanceOf(whale.address);
        console.log("usdc_balan1:",bal_usdc1); 


    })
         
});