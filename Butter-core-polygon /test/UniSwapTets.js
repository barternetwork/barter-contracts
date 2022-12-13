
const {expect} = require("chai");
const exp = require("constants");
const { sync } = require("glob");
const {ethers,network} = require("hardhat");
const { any } = require("hardhat/internal/core/params/argumentTypes");



describe("KerneUniSwapTest",function(){   
    let WHALE = '0x0349CA70eE64Dc5d5a33735b32b9a4A6f64936af';
    let PMOSTOKEN = '0xe1D8eAB4e616156E11e1c59D1a0E0EFeD66f4cfa';
    let PUSDTOEKN ='0x1E01CF4503808Fb30F17806035A87cf5A5217727';
    let whale;
    let pmos;
    let pusd; 
    let uniswap;
  
    
    beforeEach(async()=>{
        await network.provider.request({  
        method: "hardhat_impersonateAccount",
        params: [WHALE]})    

        whale =  await ethers.getSigner(WHALE);
        pmos = await ethers.getContractAt("IERC20",PMOSTOKEN);
        pusd = await ethers.getContractAt("IERC20",PUSDTOEKN);
        const Uniswap = await ethers.getContractFactory("KerneUniSwapTest");
        uniswap =  await Uniswap.deploy()
    })
 

    let _amountInArr = 10n * 10n ** 18n;

    // let _amountOutMinArr = 1n* 10n **18n;

    let _pathArr = "0x0000000000000000000000000000000000000000000000008ac7230489e800000000000000000000000000000000000000000000000000000000000000002fbe00000000000000000000000000000000000000000000000000000000000000e00000000000000000000000000349ca70ee64dc5d5a33735b32b9a4a6f64936af0000000000000000000000000000000000000000000000000000000063aa9447000000000000000000000000e1d8eab4e616156e11e1c59d1a0e0efed66f4cfa0000000000000000000000001e01cf4503808fb30f17806035a87cf5a52177270000000000000000000000000000000000000000000000000000000000000002000000000000000000000000e1d8eab4e616156e11e1c59d1a0e0efed66f4cfa0000000000000000000000001e01cf4503808fb30f17806035a87cf5a5217727";
    
    // let _deadLines = 1669617863;

    console.log(_amountInArr);

    describe("fork sushi mainnet",()=>{

        
    it("unlock caaount",async()=>{


         let bal_pmos = await pmos.balanceOf(whale.address);
         console.log("balance pmos:",bal_pmos);

         
         let bal_pusd = await pusd.balanceOf(whale.address);
         console.log("balance pusd:",bal_pusd);

         await pmos.connect(whale).approve(uniswap.address,_amountInArr);
        console.log("------------erc20 approve--------------------")

         await uniswap.connect(whale).filterSwap(_pathArr);

        let bal_pmos1 = await pmos.balanceOf(whale.address);
        console.log("balance pmos:",bal_pmos1);

        
        let bal_pusd1 = await pusd.balanceOf(whale.address);
        console.log("balance pusd:",bal_pusd1);
      })
      
    })
});