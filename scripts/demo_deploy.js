
const { ethers } = require("hardhat");

const _admins = "0x153d049aF980836c58302597CbdC58d092Df26f9";



async function setKernelUniSwapV3() {
    const kernelUniSwap = await ethers.getContractFactory("KernelUniSwapV3");
    const KernelUniSwapdemo = await kernelUniSwap.deploy();
    console.log("KernelUniSwapdemo:",KernelUniSwapdemo.address);
    }


async function setKernelSushiSwapV2() {
    const KernelSushiSwap = await ethers.getContractFactory("KernelSushiSwapV2");
    const KernelSushiSwapdemo = await KernelSushiSwap.deploy();
    console.log("KernelSushiSwapdemo:",KernelSushiSwapdemo.address);
    }



async function setKernelQuickswapv2() {
    const KernelQuickSwap = await ethers.getContractFactory("KernelQuickswapv2");
    const KernelQuickSwapdemo = await KernelQuickSwap.deploy();
    console.log("KernelQuickSwapdemo:",KernelQuickSwapdemo.address);
    }



async function setBarterswapRouter() {
const BarterswapRouter = await ethers.getContractFactory("BarterswapRouter");
const BarterswapRouterdemo = await BarterswapRouter.deploy();
console.log("KernelQuickSwapdemo:",demo.address);
}



main().then(() => process.exit(0)).catch(error => {
console.error(error);
process.exit(1);
});