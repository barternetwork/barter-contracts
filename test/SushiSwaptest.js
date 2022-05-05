
const { expect } = require('chai');
const { ethers} = require('hardhat');

describe('SushiSwaptest', () => {

  before(async function () {
  this.BarterswapRouter = await ethers.getContractFactory('SushiSwaptest');
  this.BarterswapRouterdemo = await this.BarterswapRouter.deploy();

})

})