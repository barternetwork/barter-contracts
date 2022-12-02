
const { baToJSON } = require("@nomicfoundation/ethereumjs-util");
const {expect} = require("chai");
const exp = require("constants");
const { sync } = require("glob");
const {ethers,network} = require("hardhat");
const { any } = require("hardhat/internal/core/params/argumentTypes");



describe("ButterswapRouterV1",function(){   
    let WHALE = '0x56Eddb7aa87536c09CCc2793473599fD21A8b17F';
    let USDT = '0xdAC17F958D2ee523a2206206994597C13D831ec7';
    let USDC ='0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48';
    let ButterswapRouter;
    let owenr;
    let ButterRouter;
    let addre1;
    let addre2;
    let index = 0
    let addre3;
    let whale;
    let usdc;
    let usdt;
    // let ButterSwap;


    beforeEach(async()=>{
        await network.provider.request({
        method: "hardhat_impersonateAccount",
        params: [WHALE]})    
        whale =  await ethers.getSigner(WHALE);

        usdt = await ethers.getContractAt("IERC20",USDT);
        usdc = await ethers.getContractAt("IERC20",USDC);

       [owenr,addre1,addre2,addre3] = await ethers.getSigners();

        ButterswapRouter = await ethers.getContractFactory("ButterswapRouterV1");
        ButterRouter = await ButterswapRouter.deploy(owenr.address);
        await ButterRouter.deployed()
        ButterSwap = ButterRouter.address;
        console.log("ButterswapRouter address:",ButterRouter.address);


        const _curvePool_Swap = await ethers.getContractFactory("curvePool_Swap");
        const curvePool_Swap = await _curvePool_Swap.deploy();
        await curvePool_Swap.deployed()
        addre3 = curvePool_Swap.address
        console.log("curvePool_Swap address:",curvePool_Swap.address);

    });
     




    // it("Setting feeTo address",async ()=>{
    //     let feeTos =  await ButterRouter.connect(owenr).setFeeTo(addre1.address);
    //     console.log("-----------------");
    //     console.log(feeTos);

    // })


    // it("Modification fee",async ()=>{
    //     let nwesFeses =  await ButterRouter.connect(owenr).setFees(20000000000000000);
    //     console.log("-----------------");
    //     console.log(nwesFeses);

    // })


      let _amountInArrs = 10n * 10n ** 6n;
      let  _amountOutMinArrs = 9n * 10n ** 6n;


      let  _amountInArr = [_amountInArrs];
      let  _amountOutMinArr = [_amountOutMinArrs];
      let  _pathArr= ["0x56Eddb7aa87536c09CCc2793473599fD21A8b17F"];
      let  _to = "0x56Eddb7aa87536c09CCc2793473599fD21A8b17F";
      let  _deadLine = 1600831965;
      let  _input_Out_Addre = ["0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48","0xdAC17F958D2ee523a2206206994597C13D831ec7"];
      let  _routerIndex = [0];
      let  _crv_Swap_Paramse = [[1,2,1],[0,0,0],[0,0,0],[0,0,0]];
      let  _crv_Rout =  [["0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48","0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7","0xdAC17F958D2ee523a2206206994597C13D831ec7","0x0000000000000000000000000000000000000000",
                        "0x0000000000000000000000000000000000000000","0x0000000000000000000000000000000000000000","0x0000000000000000000000000000000000000000","0x0000000000000000000000000000000000000000","0x0000000000000000000000000000000000000000"],
                        ["0x0000000000000000000000000000000000000000","0x0000000000000000000000000000000000000000","0x0000000000000000000000000000000000000000","0x0000000000000000000000000000000000000000","0x0000000000000000000000000000000000000000","0x0000000000000000000000000000000000000000","0x0000000000000000000000000000000000000000","0x0000000000000000000000000000000000000000","0x0000000000000000000000000000000000000000"]];
      let  _crv_Expected = _amountOutMinArrs;                  



    let AccessParams = {
        amountInArr:_amountInArr,
        amountOutMinArr:_amountOutMinArr,
        pathArr:_pathArr,
        to:_to,
        deadLine:_deadLine,
        input_Out_Addre:_input_Out_Addre,
        routerIndex:_routerIndex,
        crv_Route:_crv_Rout,
        crv_Swap_Params:_crv_Swap_Paramse,
        crv_Expected:_crv_Expected
    }


    it("Exchange of tokens",async ()=>{

        let nwesRouter =  await ButterRouter.connect(owenr).setRouterAddreAll(index,addre3);
        console.log("---------111111--------");
        console.log(nwesRouter);

        let bal_usdt =  await usdt.balanceOf(whale.address);
        console.log("usdt_balan:",bal_usdt); 

        let bal_usdc =  await usdc.balanceOf(whale.address);
        console.log("usdc_balan:",bal_usdc); 

        await usdc.connect(whale).approve(ButterRouter.address,_amountInArr[0]);
        // console.log(AccessParams);
        console.log(whale.address)
        console.log("------------222222--------------------")
        await ButterRouter.connect(whale).multiSwap(AccessParams);

        let bal_usdc1 =  await usdc.balanceOf(whale.address);
        console.log("usdc_balan:",bal_usdc1); 

        let bal_usdt1 =  await usdt.balanceOf(whale.address);
        console.log("usdt_balan:",bal_usdt1); 


    })
         
});