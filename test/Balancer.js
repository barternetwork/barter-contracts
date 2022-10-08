
const {expect} = require("chai");
const exp = require("constants");
const { sync } = require("glob");
const {ethers,network} = require("hardhat");
const { any } = require("hardhat/internal/core/params/argumentTypes");



describe("KernelBalancer_test",function(){   
    let USDT_WHALE = '0x56Eddb7aa87536c09CCc2793473599fD21A8b17F';
    let USDT = '0xdAC17F958D2ee523a2206206994597C13D831ec7';
    let USDC ='0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48';
    let whale;
    let usdt;
    let usdc;
    let balancer;
  

    beforeEach(async()=>{
        await network.provider.request({
        method: "hardhat_impersonateAccount",
        params: [USDT_WHALE]})    

        whale =  await ethers.getSigner(USDT_WHALE);
        usdt = await ethers.getContractAt("IERC20",USDT);
        usdc = await ethers.getContractAt("IERC20",USDC);
        const Balancer = await ethers.getContractFactory("KernelBalancer_test");
        balancer =  await Balancer.deploy()
    })
 


    // USDT -- USDC
    let swap_kind = 0;
    let swap = [{
		"poolId":'0x0d34e5dd4d8f043557145598e4e2dc286b35fd4f000000000000000000000068',
		"assetIn":'0xdAC17F958D2ee523a2206206994597C13D831ec7',
		"assetOut":'0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48',
		"amount":5000000,
        "userData":'0x'
	}]

    let FundManagement = {
        "sender":'0xf02D03CCBb925f0204541F95c534b531CaFbcE36',
        "fromInternalBalance":false,
        "recipient":'0xf02D03CCBb925f0204541F95c534b531CaFbcE36',
        "toInternalBalance":false
    }

    let limit = ['4950355'];

    let  _deadLines = new Date().getTime() + 999999;

    let  assets = ['0xdAC17F958D2ee523a2206206994597C13D831ec7','0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48'];


    
    describe("fork sushi mainnet",()=>{
    it("unlock caaount",async()=>{
      
        //  const amount = 100n * 10n **6n;
        //  await usdt.connect(whale).transfer(sushiSwap.address,amount);



        //  let bal_usdt =  await usdt.balanceOf(whale.address);
        // console.log(bal_usdt); 
        // console.log("------------111111111--------------------")
        
        //  await usdt.connect(whale).approve(balancer.address,swap[0].amount);
        // console.log("------------222222222--------------------")

        // await  balancer.connect(whale).filterBalancer(swap_kind,swap,FundManagement,assets,limit,_deadLines);
        // console.log("------------333333333--------------------")

        // balAddre2 = await usdc.balanceOf(_msgaddre);
        // console.log("获得usdc为",balAddre2);
      })

    })


});