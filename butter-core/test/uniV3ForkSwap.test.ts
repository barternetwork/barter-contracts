import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
import { ethers, network, deployments } from "hardhat";
import { BigNumber, Contract } from "ethers";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";

let deployer: SignerWithAddress;

let _user: SignerWithAddress;

let uniV3ForkSwap: Contract;

let router = "0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45";

let usdc_addr = "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48";

let weth = "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2";

let dai_addr = "0x6B175474E89094C44Da98b954EedeAC495271d0F";


let ERC20 = [
    'function approve(address spender, uint256 amount) external returns (bool)',
    'function balanceOf(address account) external view returns (uint256)',
    'function transfer(address to, uint value) external returns (bool)'
]

describe("UniV3ForkSwap", function () {

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

        let UniV3ForkSwap = await ethers.getContractFactory('UniV3ForkSwap');

        uniV3ForkSwap = await UniV3ForkSwap.deploy(router);

        await uniV3ForkSwap.connect(wallet).deployed();

    }


    describe("filterSwap", function () {


        it("filterSwap -> exactInput - in - eth", async function () {

            let [wallet, other] = await ethers.getSigners();

            await loadFixture(deployFixture);

            // (amountInArr, amountOutMinArr, pathArr, to, inputAddre, outAddre) = abi
            // .decode(
            //     exchangeData,
            //     (uint256, uint256, bytes, address, address, address)
            // );

            let amountIn = ethers.utils.parseEther("2");
            let amountOutMin = 0;
            let to = wallet.address;
            let path = "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2000bb8A0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48";
            let inputAddre = ethers.constants.AddressZero;
            let outAddre = usdc_addr;
            let data = ethers.utils.defaultAbiCoder.encode(['uint256', 'uint256', 'bytes', 'address', 'address', 'address'], [amountIn, amountOutMin, path, to, inputAddre, outAddre]);
            let usdc = await ethers.getContractAt(ERC20, usdc_addr, wallet);
            let balanceBefore = await usdc.balanceOf(wallet.address);
            await (await uniV3ForkSwap.connect(_user).filterSwap(data,{value:amountIn})).wait();
            let balanceAfter = await usdc.balanceOf(wallet.address);

            expect(balanceAfter).gt(balanceBefore);
        });

        it("filterSwap -> exactInput - in - tokens", async function () {

            let [wallet, other] = await ethers.getSigners();

            await loadFixture(deployFixture);

            // (amountInArr, amountOutMinArr, pathArr, to, inputAddre, outAddre) = abi
            // .decode(
            //     exchangeData,
            //     (uint256, uint256, bytes, address, address, address)
            // );

            let amountIn = ethers.utils.parseEther("2000");
            let amountOutMin = 0;
            let to = wallet.address;
            let path = "0x6B175474E89094C44Da98b954EedeAC495271d0F000bb8A0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48";
            let inputAddre = dai_addr;
            let outAddre = usdc_addr;
            let data = ethers.utils.defaultAbiCoder.encode(['uint256', 'uint256', 'bytes', 'address', 'address', 'address'], [amountIn, amountOutMin, path, to, inputAddre, outAddre]);
            let usdc = await ethers.getContractAt(ERC20, usdc_addr, wallet);
            let balanceBefore = await usdc.balanceOf(wallet.address);
            let dai = await ethers.getContractAt(ERC20, dai_addr, _user);
            await (await dai.transfer(uniV3ForkSwap.address, amountIn)).wait();
            await (await uniV3ForkSwap.connect(_user).filterSwap(data)).wait();
            let balanceAfter = await usdc.balanceOf(wallet.address);

            expect(balanceAfter).gt(balanceBefore);

        });

        it("filterSwap -> exactInput - out - tokens", async function () {

            let [wallet, other] = await ethers.getSigners();

            await loadFixture(deployFixture);

            // (amountInArr, amountOutMinArr, pathArr, to, inputAddre, outAddre) = abi
            // .decode(
            //     exchangeData,
            //     (uint256, uint256, bytes, address, address, address)
            // );

            let amountIn = ethers.utils.parseEther("2000");
            let amountOutMin = 0;
            let to = wallet.address;
            let path = "0x6B175474E89094C44Da98b954EedeAC495271d0F000bb8C02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2";
            let inputAddre = dai_addr;
            let outAddre = ethers.constants.AddressZero;
            let data = ethers.utils.defaultAbiCoder.encode(['uint256', 'uint256', 'bytes', 'address', 'address', 'address'], [amountIn, amountOutMin, path, to, inputAddre, outAddre]);
            let usdc = await ethers.getContractAt(ERC20, usdc_addr, wallet);
            let balanceBefore = await wallet.getBalance();
            let dai = await ethers.getContractAt(ERC20, dai_addr, _user);
            await (await dai.transfer(uniV3ForkSwap.address, amountIn)).wait();
            await (await uniV3ForkSwap.connect(_user).filterSwap(data)).wait();
            let balanceAfter = await wallet.getBalance();

            expect(balanceAfter).gt(balanceBefore);

        });

    });
});
