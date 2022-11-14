
const { baToJSON } = require("@nomicfoundation/ethereumjs-util");
const {expect} = require("chai");
const exp = require("constants");
const { sync } = require("glob");
const {ethers,network} = require("hardhat");
const { any } = require("hardhat/internal/core/params/argumentTypes");



describe("BarterswapRouterV1",function(){   
    let WHALE = '0x56Eddb7aa87536c09CCc2793473599fD21A8b17F';
    let USDT = '0xdAC17F958D2ee523a2206206994597C13D831ec7';
    let USDC ='0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48';
    let BarterswapRouter;
    let owenr;
    let barterRouter;
    let addre1;
    let addre2;
    let index = 0
    let addre3;
    let whale;
    let usdc;
    let usdt;
    // let barterSwap;

    let _curvePool_Swap;
    let curvePool_Swap;

    beforeEach(async()=>{
        await network.provider.request({
        method: "hardhat_impersonateAccount",
        params: [WHALE]})    
        whale =  await ethers.getSigner(WHALE);

        usdt = await ethers.getContractAt("IERC20",USDT);
        usdc = await ethers.getContractAt("IERC20",USDC);

       [owenr,addre1,addre2,addre3] = await ethers.getSigners();

        BarterswapRouter = await ethers.getContractFactory("BarterswapRouterV1");
        barterRouter = await BarterswapRouter.deploy(owenr.address);
        await barterRouter.deployed()
        barterSwap = barterRouter.address;
        console.log("BarterswapRouter address:",barterRouter.address);


        const _curvePool_Swap = await ethers.getContractFactory("curvePool_Swap");
        const curvePool_Swap = await _curvePool_Swap.deploy();
        await curvePool_Swap.deployed()
        addre3 = curvePool_Swap.address
        console.log("curvePool_Swap address:",curvePool_Swap.address);

    });
     




    it("Setting feeTo address",async ()=>{
        let feeTos =  await barterRouter.connect(owenr).setFeeTo(addre1.address);
        console.log("-----------------");
        console.log(feeTos);

    })

    // it("Modifying Administrator Rights",async()=>{
    //     let nwesOwenr =  await barterRouter.connect(owenr).setFeeToSetter(addre2.address);
    //     console.log("-----------------");
    //     console.log(nwesOwenr);

    // })


    it("Modification fee",async ()=>{
        let nwesFeses =  await barterRouter.connect(owenr).setFees(20000000000000000);
        console.log("-----------------");
        console.log(nwesFeses);

    })


    // it("Add route subscripts and addresses",async ()=>{
    //     let nwesRouter =  await barterRouter.connect(owenr).setRouterAddreAll(index,addre3.address);
    //     console.log("-----------------");
    //     console.log(nwesRouter);

    // })
    
      

      let  _amountInArr = [100000000];
      let  _amountOutMinArr = [95000000];
      let  _pathArr= ["0x56Eddb7aa87536c09CCc2793473599fD21A8b17F"];
      let  _to = "0x56Eddb7aa87536c09CCc2793473599fD21A8b17F";
      let  _deadLine = 1600831965;
      let  _input_Out_Addre = ["0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48","0xdAC17F958D2ee523a2206206994597C13D831ec7"];
      let  _routerIndex = [0];
      let  _crv_Swap_Paramse = [[1,2,1],[0,0,0],[0,0,0],[0,0,0]];
      let  _crv_Rout =  [["0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48","0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7","0xdAC17F958D2ee523a2206206994597C13D831ec7","0x0000000000000000000000000000000000000000",
                        "0x0000000000000000000000000000000000000000","0x0000000000000000000000000000000000000000","0x0000000000000000000000000000000000000000","0x0000000000000000000000000000000000000000","0x0000000000000000000000000000000000000000"],
                        ["0x0000000000000000000000000000000000000000","0x0000000000000000000000000000000000000000","0x0000000000000000000000000000000000000000","0x0000000000000000000000000000000000000000","0x0000000000000000000000000000000000000000","0x0000000000000000000000000000000000000000","0x0000000000000000000000000000000000000000","0x0000000000000000000000000000000000000000","0x0000000000000000000000000000000000000000"]];
      let  _crv_Expected = 950000000;                  
        


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

    // console.log(AccessParams);

    
    // let adree01 = "0x15d34AAf54267DB7D7c367839AAf71A00a2C6A65";

    it("Exchange of tokens",async ()=>{

        let nwesRouter =  await barterRouter.connect(owenr).setRouterAddreAll(index,addre3);
        console.log("---------111111--------");
        console.log(nwesRouter);


        await usdc.connect(whale).approve(barterRouter.address,_amountInArr[0]);
        console.log(AccessParams);
        console.log(whale.address)
        console.log("------------222222--------------------")
        await barterRouter.connect(whale).multiSwap(AccessParams);

    })


    // it("Exchange of tokens",async ()=>{

    //     let nwesRouter =  await barterRouter.connect(owenr).setRouterAddreAll(index,addre3.address);
    //     console.log("-----------------");
    //     console.log(nwesRouter);

    // })


         
});