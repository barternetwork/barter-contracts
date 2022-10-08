
const {expect} = require("chai");
const exp = require("constants");
const { sync } = require("glob");
const {ethers,network} = require("hardhat");
const { any } = require("hardhat/internal/core/params/argumentTypes");



describe("KernelCurve_test",function(){   
    let USDT_WHALE = '0x56Eddb7aa87536c09CCc2793473599fD21A8b17F';
    let USDT = '0xdAC17F958D2ee523a2206206994597C13D831ec7';
    let USDC ='0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48';
    let whale;
    let usdt;
    let usdc;
    let curveSwap

    beforeEach(async()=>{
        await network.provider.request({
        method: "hardhat_impersonateAccount",
        params: [USDT_WHALE]})    

        whale =  await ethers.getSigner(USDT_WHALE);
        usdt = await ethers.getContractAt("IERC20",USDT);
        usdc = await ethers.getContractAt("IERC20",USDC);
        const CurveSwap = await ethers.getContractFactory("CurveSwap_test");
        curveSwap =  await CurveSwap.deploy()
    })
 

    // let   _initial = '0xdAC17F958D2ee523a2206206994597C13D831ec7';
    // let   _target = '0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48';
    // let  _amount = 1000000;

    // USDT -- USDC
    let  _initial =["0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48","0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7","0xdAC17F958D2ee523a2206206994597C13D831ec7","0xdAC17F958D2ee523a2206206994597C13D831ec7","0x0000000000000000000000000000000000000000","0x0000000000000000000000000000000000000000"];
    let  _target = [1,2,0,0,0,0,0,0];
    let  _min_received = 0;

    // USDT
    // let   _initial = ["0x0000000000000000000000000000000000000000","0x0000000000000000000000000000000000000000","0xdAC17F958D2ee523a2206206994597C13D831ec7","0xdAC17F958D2ee523a2206206994597C13D831ec7","0x4e0915C88bC70750D68C481540F081fEFaF22273","0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48"];
    // let   _target = [0,0,0,0,0,1,0,0];
    // let  _min_received = 0;
    let  amount = 10000000;
    
    // let  usdt_a = "0xdAC17F958D2ee523a2206206994597C13D831ec7";
    // let  whales = 0x56Eddb7aa87536c09CCc2793473599fD21A8b17F;

    describe("fork mainnet",()=>{
      it("unlock caaount",async()=>{

        // Data  =  await curveSwap.get_exchange_routings(_initial,_target,_amount);
        // console.log(Data[0]);
        let bal_usdc =  await usdc.balanceOf(whale.address);
        console.log(bal_usdc); 
        console.log("------------111111111--------------------")

        // const amounts = 10n * 10n ** 6n;
        // await usdt.connect(whale).transfer(curveSwap.address,amount);
        // console.log(1111111);

        // let curveaddr = await usdt.balanceOf(curveSwap.address);
        // console.log(curveaddr);
        // console.log(2222222);
        
        await usdc.connect(whale).approve(curveSwap.address,amount);
        console.log("------------222222222--------------------")
        await  curveSwap.connect(whale).filterCurve(amount,usdc.address,_initial,_target,_min_received,whale.address);
        console.log("------------333333333--------------------")

        let bala_usdt = await usdc.balanceOf(curveSwap.address);
        console.log(bala_usdt);
      })

    })


});