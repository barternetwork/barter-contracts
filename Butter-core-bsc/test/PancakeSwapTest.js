
const {expect} = require("chai");
const exp = require("constants");
const { sync } = require("glob");
const {ethers,network} = require("hardhat");
const { any } = require("hardhat/internal/core/params/argumentTypes");



describe("PancakeSwap_Test",function(){   
    let WHALE = '0x0349CA70eE64Dc5d5a33735b32b9a4A6f64936af';
    let BMOS = '0x0349CA70eE64Dc5d5a33735b32b9a4A6f64936af';
    let BUSD ='0x3F1E91BFC874625f4ee6EF6D8668E79291882373';
    let whale;
    let bmos;
    let busd;
    let pancakeSwap
  

    beforeEach(async()=>{
        await network.provider.request({
        method: "hardhat_impersonateAccount",
        params: [WHALE]})    

        whale =  await ethers.getSigner(WHALE);
        bmos = await ethers.getContractAt("IERC20",BMOS);
        busd = await ethers.getContractAt("IERC20",BUSD);
        const PancakeSwap = await ethers.getContractFactory("PancakeSwap_Test");
        pancakeSwap =  await PancakeSwap.deploy()
    })
 

    let _amountInArr =  10n * 10n **18n;

    // let _amountOutMinArr = 9n* 10n **18n;

    let _pathArr = "0x0000000000000000000000000000000000000000000000008ac7230489e800000000000000000000000000000000000000000000000000007ce66c50e284000000000000000000000000000000000000000000000000000000000000000000e00000000000000000000000005b83802bf19832e76b98ddf4fc775357562ade2d0000000000000000000000000000000000000000000000000000000063abe5c7000000000000000000000000bb4cdb9cbd36b01bd1cbaebf2de08d9173bc095c0000000000000000000000008ac76a51cc950d9822d68b83fe1ad97b32cd580d0000000000000000000000000000000000000000000000000000000000000002000000000000000000000000bb4cdb9cbd36b01bd1cbaebf2de08d9173bc095c0000000000000000000000008ac76a51cc950d9822d68b83fe1ad97b32cd580d";
    
    // let _deadLines = 1669617863;



    describe("fork Pancake mainnet",()=>{
    it("unlock caaount",async()=>{

        let bal_bmos =  await bmos.balanceOf(whale.address);
        console.log("balance wbnb :",bal_bmos); 



        let bal_busd = await busd.balanceOf(whale.address);
        console.log("balance usdc :",bal_busd);


      
        await wbnb.connect(whale).approve(pancakeSwap.address,_amountInArr);
        console.log("------------erc20 approve--------------------")

        // await  pancakeSwap.connect(whale).filterSwap(_pathArr);
        // console.log("------------ swap Success --------------------")

        // let bal_wbnb1 =  await wbnb.balanceOf(whale.address);
        // console.log("balance wbnb1 :",bal_wbnb1); 


        // let bal_usdc2 = await usdc.balanceOf(whale.address);
        // console.log("balanceOf_usdc:",bal_usdc2);
      })

    })

});