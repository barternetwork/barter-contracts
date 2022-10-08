

const {expect} = require("chai");
const { sync } = require("glob");
const {ethers} = require("hardhat");
const { any } = require("hardhat/internal/core/params/argumentTypes");



describe("Token",function(){
  
    let Token,token,owner,addre
    beforeEach(async()=>{
      Token = await ethers.getContractFactory("Token");
      token = await Token.deploy();
      [owner,addre] = await ethers.getSigners();
    })


    describe("test Deployment",()=>{
      it('owner yes',async()=>{
          expect(await token.owner()).to.equal(owner.address);
        })
    })

    describe("owner totalSupply", async()=>{
      const totalSupplys = await token.totalSupply();
      expect(await token.balanceOf(owner.address)).to.equal(totalSupply);
    })

    describe('transfer token',()=>{
      it("transfer tokens",async()=>{
        await token.transfer(addre.address,100);
        const balAddre = await token.balanceOf(addre.address);
        console.log(balAddre);
        console.log(balAddre == 100);
        expect(balAddre).to.equal(100);
      })
    })

});


