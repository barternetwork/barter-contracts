import { BigNumber } from "ethers";
import { ethers, network } from "hardhat";
import { getSwaps } from "./config"

async function main() {

  await deploy();

}


async function deploy() {

  let [wallet] = await ethers.getSigners();
  console.log("deployer address is :", wallet.address);
  const ButterCore = await ethers.getContractFactory("ButterCore");
  const butterCore = await ButterCore.deploy();
  await butterCore.deployed();
  console.log(`butterCore deployed to ${butterCore.address}`);

  const UniV2ForkSwap = await ethers.getContractFactory("UniV2ForkSwap");
  const uniV2ForkSwap = await UniV2ForkSwap.deploy();
  await uniV2ForkSwap.deployed();
  console.log(`uniV2 fork swap handle deployed to ${uniV2ForkSwap.address}`);
  await (await butterCore.setSwapTypeHandle(1, uniV2ForkSwap.address)).wait();

  if (network.name.indexOf('bsc') === -1) { // eth  or matic
    let UniV3ForkSwap = await ethers.getContractFactory('UniV3ForkSwap');
    let uniV3ForkSwap = await UniV3ForkSwap.deploy();
    await uniV3ForkSwap.connect(wallet).deployed();
    console.log(`uniV3 fork swap handle deployed to ${uniV3ForkSwap.address}`);
    await (await butterCore.setSwapTypeHandle(2, uniV3ForkSwap.address)).wait();
    if (network.name.indexOf('mainnet') > -1) {
      let CurveForkSwap = await ethers.getContractFactory('CurveForkSwap');
      let curveForkSwap = await CurveForkSwap.deploy();
      await curveForkSwap.connect(wallet).deployed();
      console.log(`curve fork swap handle deployed to ${curveForkSwap.address}`);
      await (await butterCore.setSwapTypeHandle(3, curveForkSwap.address)).wait();
    }
  }

  let swaps = getSwaps(network.name);
  if (swaps.length == 0) {
    return;
  }
  for (let i = 0; i < swaps.length; i++) {
    let swap = swaps[i];
    let config = {
      swapRouter: swap.router,
      swapType: swap.type
    }
    await (await butterCore.setSwapConfig(swap.index, config)).wait();
    console.log(`set index ${swap.index} for ${swap.name}`);
  }

}






// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
