
const {expect} = require("chai");
const exp = require("constants");
const { sync } = require("glob");
const {ethers,network} = require("hardhat");
const { any } = require("hardhat/internal/core/params/argumentTypes");



describe("CurvePool_Swap_Test",function(){   
    let USDT_WHALE = '0x56Eddb7aa87536c09CCc2793473599fD21A8b17F';
    let USDT = '0xdAC17F958D2ee523a2206206994597C13D831ec7';
    let USDC ='0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48';
    let whale;
    let usdt;
    let usdc;
    let curve_Pool;

    beforeEach(async()=>{
        await network.provider.request({
        method: "hardhat_impersonateAccount",
        params: [USDT_WHALE]})    

        whale =  await ethers.getSigner(USDT_WHALE);
        usdt = await ethers.getContractAt("IERC20",USDT);
        usdc = await ethers.getContractAt("IERC20",USDC);
        const Curve_Pool = await ethers.getContractFactory("CurvePool_Swap_Test");
        curve_Pool =  await Curve_Pool.deploy()
    })
    
    let  route = ["0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48","0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7","0xdAC17F958D2ee523a2206206994597C13D831ec7","0x0000000000000000000000000000000000000000",
                  "0x0000000000000000000000000000000000000000","0x0000000000000000000000000000000000000000","0x0000000000000000000000000000000000000000","0x0000000000000000000000000000000000000000","0x0000000000000000000000000000000000000000"]
                    
    let inputAddre = "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48";

    let swap_params = [[1,2,1],[0,0,0],[0,0,0],[0,0,0]];

    let  amounts = 100000000;

    let  expected = 950000000;

    let pools = ["0x0000000000000000000000000000000000000000","0x0000000000000000000000000000000000000000","0x0000000000000000000000000000000000000000","0x0000000000000000000000000000000000000000"];

    // let outaddres = "0xdAC17F958D2ee523a2206206994597C13D831ec7";

    let receiver = '0x0349CA70eE64Dc5d5a33735b32b9a4A6f64936af';

    describe("fork mainnet",()=>{
      it("unlock caaount",async()=>{
        // Data  =  await curveSwap.get_exchange_routings(_initial,_target,_amount);
        // console.log(Data[0]);
        let bal_usdc =  await usdc.balanceOf(whale.address);
        console.log(bal_usdc); 

        let bal_usdt =  await usdt.balanceOf(whale.address);
        console.log(bal_usdt); 
        console.log("------------111111111--------------------")


        // const amounts = 10n * 10n ** 6n;
        // await usdc.connect(whale).transfer(curve_Pool.address,amounts);
        // console.log("-------------2222222------------------");

        // let curveaddr = await usdc.balanceOf(curve_Pool.address);
        // console.log("amounts:",curveaddr);
      
        
        await usdc.connect(whale).approve(curve_Pool.address,amounts);
        console.log("------------333333333--------------------")


      // let shuju =   await  curve_Pool.connect(whale).get_best_rates(inputAddre,outaddres,amounts);
      // console.log(shuju);

        //  let received_Token =  await  curve_Pool.connect(whale).exchange_Multiples(inputAddre,route,swap_params,amounts,expected,pools,USDT_WHALE);
        // console.log(received_Token);
        
        let received_Token =  await  curve_Pool.connect(whale).exchange_Multiples(inputAddre,route,swap_params,amounts,expected,pools,whale.address);
        console.log(received_Token)
        console.log("------------44444--------------------")
        

        let _bal_usdc =  await usdc.balanceOf(whale.address);
        console.log(_bal_usdc); 

        let curve_Pool_balan = await usdc.balanceOf(curve_Pool.address);
        console.log("user_usdt:",curve_Pool_balan);

        let turve_usdt = await usdt.balanceOf(whale.address);
        console.log("user_usdt:",turve_usdt);

        // let turve_usdc = await usdc.balanceOf(curve_Pool.address);
        // console.log("user_usdc:",turve_usdc);

      })

    })


});