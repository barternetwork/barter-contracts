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
  const butterCore = await ButterCore.deploy(wallet.address);
  await butterCore.deployed();
  console.log(`butterCore deployed to ${butterCore.address}`);
  let swaps = getSwaps(network.name);
  if (swaps.length == 0) {
    return;
  }

  for (let i = 0; i < swaps.length; i++) {

    let swap = swaps[i];
    if (swap.type === 1) {

      const UniV2ForkSwap = await ethers.getContractFactory("UniV2ForkSwap");
      const uniV2ForkSwap = await UniV2ForkSwap.deploy(swap.router);
      await uniV2ForkSwap.deployed();
      console.log(`${swap.name} wrap deployed to ${uniV2ForkSwap.address}`);
      await (await butterCore.setRouterAddreAll(swap.index, uniV2ForkSwap.address));
      console.log(`set index ${swap.index} for ${swap.name}`);
    } else if (swap.type === 2) {

      const UnisV3ForkSwap = await ethers.getContractFactory("UnisV3ForkSwap");
      const unisV3ForkSwap = await UnisV3ForkSwap.deploy(swap.router);
      await unisV3ForkSwap.deployed();
      console.log(`${swap.name} wrap deployed to ${unisV3ForkSwap.address}`);
      await (await butterCore.setRouterAddreAll(swap.index, unisV3ForkSwap.address));
      console.log(`set index ${swap.index} for ${swap.name}`);
    } else if (swap.type === 3) {

      const CurveForkSwap = await ethers.getContractFactory("CurveForkSwap");
      const curveForkSwap = await CurveForkSwap.deploy(swap.router);
      await curveForkSwap.deployed();
      console.log(`${swap.name} wrap deployed to ${curveForkSwap.address}`);
      await (await butterCore.setRouterAddreAll(swap.index, curveForkSwap.address));
      console.log(`set index ${swap.index} for ${swap.name}`);
    }
  }

}






// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
