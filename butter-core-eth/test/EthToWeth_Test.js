
const { baToJSON } = require("@nomicfoundation/ethereumjs-util");
const {expect} = require("chai");
const exp = require("constants");
const { sync } = require("glob");
const {ethers,network} = require("hardhat");
const { any } = require("hardhat/internal/core/params/argumentTypes");



describe("ethExchangeWeth",function(){   
    let WHALE = '0x56Eddb7aa87536c09CCc2793473599fD21A8b17F';
    let WETH = "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2";

    let EthExchangeWeth;
    let ethExchangeWeth;
    let weth;
    let whale;

    let amount = 10n * 10n ** 18n;

    beforeEach(async()=>{
        await network.provider.request({
        method: "hardhat_impersonateAccount",
        params: [WHALE]})    
        whale =  await ethers.getSigner(WHALE);
        weth = await ethers.getContractAt("IERC20",WETH);

        EthExchangeWeth = await ethers.getContractFactory("ethExchangeWeth");
        ethExchangeWeth = await EthExchangeWeth.deploy();
        console.log(ethExchangeWeth.address);
    });
     


    it("Swap of tokens",async ()=>{

        let weths =  await weth.balanceOf(whale.address);
        console.log(weths); 
      await ethExchangeWeth.connect(whale).ethToWeth(amount,whale.address,{value:"10000000000000000000"});
        console.log("-----------------");
        let swapWeth =  await weth.balanceOf(whale.address);
        console.log(swapWeth); 

    })


         
});