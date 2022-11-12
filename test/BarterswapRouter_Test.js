
const { baToJSON } = require("@nomicfoundation/ethereumjs-util");
const {expect} = require("chai");
const exp = require("constants");
const { sync } = require("glob");
const {ethers,network} = require("hardhat");
const { any } = require("hardhat/internal/core/params/argumentTypes");



describe("BarterswapRouterV1",function(){   
    let USDT_WHALE = '0x56Eddb7aa87536c09CCc2793473599fD21A8b17F';
    let USDT = '0xdAC17F958D2ee523a2206206994597C13D831ec7';
    let USDC ='0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48';
    let BarterswapRouter;
    let owenr;
    let barterRouter;
    let addre1;
    let addre2;
    let fees = 3;
    let index = 1
    let addre3


    beforeEach(async()=>{
        await network.provider.request({
        method: "hardhat_impersonateAccount",
        params: [USDT_WHALE]})    
        whale =  await ethers.getSigner(USDT_WHALE);

       [owenr,addre1,addre2,addre3] = await ethers.getSigners();

        BarterswapRouter = await ethers.getContractFactory("BarterswapRouterV1");
        barterRouter = await BarterswapRouter.deploy(owenr.address);
        await barterRouter.deployed()

        console.log(barterRouter.address);
        console.log("--------");
    });
     


    it("Setting feeTo address",async ()=>{
        let feeTos =  await barterRouter.connect(owenr).setFeeTo(addre1.address);
        console.log("-----------------");
        console.log(feeTos);

    })

    it("Modifying Administrator Rights",async()=>{
        let nwesOwenr =  await barterRouter.connect(owenr).setFeeToSetter(addre2.address);
        console.log("-----------------");
        console.log(nwesOwenr);

    })


    it("Modification fee",async ()=>{
        let nwesFeses =  await barterRouter.connect(owenr).setFees(fees);
        console.log("-----------------");
        console.log(nwesFeses);

    })


    it("Add route subscripts and addresses",async ()=>{
        let nwesRouter =  await barterRouter.connect(owenr).setRouterAddreAll(index,addre3.address);
        console.log("-----------------");
        console.log(nwesRouter);

    })
         
});