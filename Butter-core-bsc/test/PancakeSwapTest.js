
const {expect} = require("chai");
const exp = require("constants");
const { sync } = require("glob");
const {ethers,network} = require("hardhat");
const { any } = require("hardhat/internal/core/params/argumentTypes");



describe("PancakeSwap_Test",function(){   
    let WHALE = '0x5B83802bF19832e76b98DDf4fC775357562aDe2D';
    let WBNB = '0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c';
    let USDC ='0x8AC76a51cc950d9822D68b83fE1Ad97B32Cd580d';
    let whale;
    let wbnb;
    let usdc;
    let pancakeSwap
  

    beforeEach(async()=>{
        await network.provider.request({
        method: "hardhat_impersonateAccount",
        params: [WHALE]})    

        whale =  await ethers.getSigner(WHALE);
        wbnb = await ethers.getContractAt("IERC20",WBNB);
        usdc = await ethers.getContractAt("IERC20",USDC);
        const PancakeSwap = await ethers.getContractFactory("PancakeSwap_Test");
        pancakeSwap =  await PancakeSwap.deploy()
    })
 

    let _amountInArr =  10n * 10n **18n;

    // let _amountOutMinArr = 9n* 10n **18n;

    let _pathArr = "0x0000000000000000000000000000000000000000000000008ac7230489e800000000000000000000000000000000000000000000000000007ce66c50e284000000000000000000000000000000000000000000000000000000000000000000e00000000000000000000000005b83802bf19832e76b98ddf4fc775357562ade2d0000000000000000000000000000000000000000000000000000000063abe5c7000000000000000000000000bb4cdb9cbd36b01bd1cbaebf2de08d9173bc095c0000000000000000000000008ac76a51cc950d9822d68b83fe1ad97b32cd580d0000000000000000000000000000000000000000000000000000000000000002000000000000000000000000bb4cdb9cbd36b01bd1cbaebf2de08d9173bc095c0000000000000000000000008ac76a51cc950d9822d68b83fe1ad97b32cd580d";
    
    // let _deadLines = 1669617863;



    describe("fork sushi mainnet",()=>{
    it("unlock caaount",async()=>{

        let bal_wbnb =  await wbnb.balanceOf(whale.address);
        console.log("balance wbnb :",bal_wbnb); 



        let bal_usdc = await usdc.balanceOf(whale.address);
        console.log("balance usdc :",bal_usdc);


      
        await wbnb.connect(whale).approve(pancakeSwap.address,_amountInArr);
        console.log("------------erc20 approve--------------------")

        await  pancakeSwap.connect(whale).filterSwap(_pathArr);
        console.log("------------ swap Success --------------------")

        let bal_wbnb1 =  await wbnb.balanceOf(whale.address);
        console.log("balance wbnb1 :",bal_wbnb1); 


        let bal_usdc2 = await usdc.balanceOf(whale.address);
        console.log("balanceOf_usdc:",bal_usdc2);
      })

    })

});