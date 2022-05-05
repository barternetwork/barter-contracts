const { expect } = require('chai') ;
const { ethers} = require('hardhat') ;

describe('Uniswaptest', () => {

  before(async function () {
  this.BarterswapRouter = await ethers.getContractFactory('Uniswaptest');
  this.BarterswapRouterdemo = await this.BarterswapRouter.deploy();

})

})