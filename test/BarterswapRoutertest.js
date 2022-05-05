const { expect } = require('chai') ;
const { ethers} = require('hardhat') ;

describe('BarterswapRoutertest', () => {

  before(async function () {
  this.BarterswapRouter = await ethers.getContractFactory('BarterswapRoutertest');
  this.BarterswapRouterdemo = await this.BarterswapRouter.deploy();

})


})