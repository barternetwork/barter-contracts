// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");


async function main() {

  let owenr;
  [owenr] = await ethers.getSigners();
  const BarterswapRouter = await ethers.getContractFactory("BarterswapRouterV1");
  const barterRouter = await BarterswapRouter.deploy(owenr.address);
  await barterRouter.deployed()

  console.log(barterRouter.address);
  console.log("----1111----");



  const _curvePool_Swap = await ethers.getContractFactory("curvePool_Swap");
  const curvePool_Swap = await _curvePool_Swap.deploy();
  await curvePool_Swap.deployed()

  console.log(barterRouter.address);
  console.log("---2222-----");




}





// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
.then(()=> process.exit(0))
.catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
