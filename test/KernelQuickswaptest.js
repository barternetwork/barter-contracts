const { expect } = require('chai');
const { ethers} = require('hardhat');

describe('Quickswaptest', () => {

  before(async function () {
  this.BarterswapRouter = await ethers.getContractFactory('Quickswaptest')
  this.BarterswapRouterdemo = await this.BarterswapRouter.deploy()

})

})