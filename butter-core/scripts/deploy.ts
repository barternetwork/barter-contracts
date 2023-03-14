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
