import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
import { ethers, network, deployments } from "hardhat";
import { BigNumber, Contract } from "ethers";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";

let deployer: SignerWithAddress;

let _user: SignerWithAddress;

let uniV2ForkSwap: Contract;

let router = "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D";

let usdc_addr = "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48";

let weth = "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2";

let dai_addr = "0x6B175474E89094C44Da98b954EedeAC495271d0F";


let ERC20 = [
    'function approve(address spender, uint256 amount) external returns (bool)',
    'function balanceOf(address account) external view returns (uint256)',
    'function transfer(address to, uint value) external returns (bool)'
]

describe("UniV2ForkSwap", function () {

    async function deployFixture() {

        let [wallet] = await ethers.getSigners();
        await network.provider.request({
            method: 'hardhat_impersonateAccount',
            params: ['0xf60c2Ea62EDBfE808163751DD0d8693DCb30019c'],
        })
        _user = await ethers.getSigner('0xf60c2Ea62EDBfE808163751DD0d8693DCb30019c')
        await network.provider.request({
            method: 'hardhat_impersonateAccount',
            params: ['0x18916e1a2933Cb349145A280473A5DE8EB6630cb'],
        })
        deployer = await ethers.getSigner('0x18916e1a2933Cb349145A280473A5DE8EB6630cb')

        let tx = {
            to: wallet.address,
            value: ethers.utils.parseEther('1')
        };

        await (await deployer.sendTransaction(tx)).wait();

        let UniV2ForkSwap = await ethers.getContractFactory('UniV2ForkSwap');

        uniV2ForkSwap = await UniV2ForkSwap.deploy(router);

        await uniV2ForkSwap.connect(wallet).deployed();

    }


    describe("filterSwap", function () {


        it("filterSwap -> swapExactETHForTokens", async function () {

            let [wallet, other] = await ethers.getSigners();

            await loadFixture(deployFixture);

            let amountIn = ethers.utils.parseEther("2");
            let deadLines = Math.floor(Date.now() / 1000) + 60 * 20;
            let amountOutMin = 0;
            let to = wallet.address;
            let path = [weth, usdc_addr];
            let inputAddre = ethers.constants.AddressZero;
            let outAddre = usdc_addr;
            let data = ethers.utils.defaultAbiCoder.encode(['uint256', 'uint256', 'address[]', 'address', 'uint256', 'address', 'address'], [amountIn, amountOutMin, path, to, deadLines, inputAddre, outAddre]);
            let usdc = await ethers.getContractAt(ERC20, usdc_addr, wallet);
            let balanceBefore = await usdc.balanceOf(wallet.address);
            await (await uniV2ForkSwap.connect(_user).filterSwap(data, { value: amountIn })).wait();
            let balanceAfter = await usdc.balanceOf(wallet.address);

            expect(balanceAfter).gt(balanceBefore);
        });

        it("filterSwap -> swapExactTokensForTokens", async function () {

            let [wallet, other] = await ethers.getSigners();

            await loadFixture(deployFixture);

            let amountIn = ethers.utils.parseEther("2000");
            let deadLines = Math.floor(Date.now() / 1000) + 60 * 20;
            let amountOutMin = 0;
            let to = wallet.address;
            let path = [dai_addr, usdc_addr];
            let inputAddre = dai_addr;
            let outAddre = usdc_addr;
            let data = ethers.utils.defaultAbiCoder.encode(['uint256', 'uint256', 'address[]', 'address', 'uint256', 'address', 'address'], [amountIn, amountOutMin, path, to, deadLines, inputAddre, outAddre]);
            let usdc = await ethers.getContractAt(ERC20, usdc_addr, wallet);
            let dai = await ethers.getContractAt(ERC20, dai_addr, _user);
            await (await dai.transfer(uniV2ForkSwap.address, amountIn)).wait();
            let balanceBefore = await usdc.balanceOf(wallet.address);
            await (await uniV2ForkSwap.connect(_user).filterSwap(data, { value: amountIn })).wait();
            let balanceAfter = await usdc.balanceOf(wallet.address);

            expect(balanceAfter).gt(balanceBefore);

        });

        it("filterSwap -> swapExactTokensForETH", async function () {

            let [wallet, other] = await ethers.getSigners();

            await loadFixture(deployFixture);

            let amountIn = ethers.utils.parseEther("2000");
            let deadLines = Math.floor(Date.now() / 1000) + 60 * 20;
            let amountOutMin = 0;
            let to = wallet.address;
            let path = [dai_addr, weth];
            let inputAddre = dai_addr;
            let outAddre = ethers.constants.AddressZero;
            let data = ethers.utils.defaultAbiCoder.encode(['uint256', 'uint256', 'address[]', 'address', 'uint256', 'address', 'address'], [amountIn, amountOutMin, path, to, deadLines, inputAddre, outAddre]);

            let dai = await ethers.getContractAt(ERC20, dai_addr, _user);
            await (await dai.transfer(uniV2ForkSwap.address, amountIn)).wait();
            let balanceBefore = await wallet.getBalance();
            await (await uniV2ForkSwap.connect(_user).filterSwap(data, { value: amountIn })).wait();
            let balanceAfter = await wallet.getBalance();

            expect(balanceAfter).gt(balanceBefore);
        });

    });
});
