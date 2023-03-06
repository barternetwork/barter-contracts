import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
import { ethers, network, deployments } from "hardhat";
import { BigNumber, Contract } from "ethers";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";

let deployer: SignerWithAddress;

let _user: SignerWithAddress;

let curveForkSwap: Contract;

let router = "0x99a58482BD75cbab83b27EC03CA68fF489b5788f";

let usdc_addr = "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48";

let weth = "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2";

let dai_addr = "0x6B175474E89094C44Da98b954EedeAC495271d0F";


let ERC20 = [
    'function approve(address spender, uint256 amount) external returns (bool)',
    'function balanceOf(address account) external view returns (uint256)',
    'function transfer(address to, uint value) external returns (bool)'
]

describe("curveForkSwap", function () {

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

        let CurveForkSwap = await ethers.getContractFactory('CurveForkSwap');

        curveForkSwap = await CurveForkSwap.deploy(router);
        await curveForkSwap.connect(wallet).deployed();

    }

            // address inputAddre;
            // address[9] memory route;
            // uint256[3][4] memory swap_params;
            // uint256 amount;
            // uint256 expected;
            // address[4] memory pools;
            // address receiver;
            // (
            //     inputAddre,
            //     route,
            //     swap_params,
            //     amount,
            //     expected,
            //     pools,
            //     receiver
            // ) = abi.decode(
            //     exchangeData,
            //     (
            //         address,
            //         address[9],
            //         uint256[3][4],
            //         uint256,
            //         uint256,
            //         address[4],
            //         address
            //     )
            // );
    describe("filterSwap", function () {


        it("filterSwap -> exchange_multiple in tokens ", async function () {

            let [wallet, other] = await ethers.getSigners();

            await loadFixture(deployFixture);

            let amount = ethers.utils.parseEther("2000");
            let expected = 0;
            let receiver = wallet.address;
            let route = [dai_addr, "0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7", usdc_addr, "0x0000000000000000000000000000000000000000", "0x0000000000000000000000000000000000000000", "0x0000000000000000000000000000000000000000", "0x0000000000000000000000000000000000000000", "0x0000000000000000000000000000000000000000", "0x0000000000000000000000000000000000000000"];
            let inputAddre = dai_addr;
            let swap_params = [[0, 1, 1], [0, 0, 0], [0, 0, 0], [0, 0, 0]];
            let pools = ["0x0000000000000000000000000000000000000000", "0x0000000000000000000000000000000000000000", "0x0000000000000000000000000000000000000000", "0x0000000000000000000000000000000000000000"]
            let data = ethers.utils.defaultAbiCoder.encode(['address', 'address[9]', 'uint256[3][4]', 'uint256', 'uint256', 'address[4]','address'], [inputAddre, route, swap_params, amount, expected, pools,receiver]);
            let usdc = await ethers.getContractAt(ERC20, usdc_addr, wallet);
            let balanceBefore = await usdc.balanceOf(wallet.address);
            let dai = await ethers.getContractAt(ERC20, dai_addr, _user);
            await (await dai.transfer(curveForkSwap.address, amount)).wait();
            await (await curveForkSwap.connect(_user).filterSwap(data)).wait();
            let balanceAfter = await usdc.balanceOf(wallet.address);

            expect(balanceAfter).gt(balanceBefore);
        });

        it("filterSwap -> exactInput - in - eth", async function () {
            let [wallet, other] = await ethers.getSigners();

            await loadFixture(deployFixture);


            let amount = ethers.utils.parseEther("4");
            let expected = 0;
            let receiver = wallet.address;
            let route = ["0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE", "0xD51a44d3FaE010294C616388b506AcdA1bfAAE46","0xdAC17F958D2ee523a2206206994597C13D831ec7","0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7" ,usdc_addr, "0x0000000000000000000000000000000000000000", "0x0000000000000000000000000000000000000000", "0x0000000000000000000000000000000000000000", "0x0000000000000000000000000000000000000000"];
            let inputAddre = ethers.constants.AddressZero;
            let swap_params = [[2, 0, 3], [2, 1, 1], [0, 0, 0], [0, 0, 0]];
            let pools = ["0x0000000000000000000000000000000000000000", "0x0000000000000000000000000000000000000000", "0x0000000000000000000000000000000000000000", "0x0000000000000000000000000000000000000000"]
            let data = ethers.utils.defaultAbiCoder.encode(['address', 'address[9]', 'uint256[3][4]', 'uint256', 'uint256', 'address[4]','address'], [inputAddre, route, swap_params, amount, expected, pools,receiver]);
            let usdc = await ethers.getContractAt(ERC20, usdc_addr, wallet);
            let balanceBefore = await usdc.balanceOf(wallet.address);
            await (await curveForkSwap.connect(_user).filterSwap(data,{value:amount})).wait();
            let balanceAfter = await usdc.balanceOf(wallet.address);

            expect(balanceAfter).gt(balanceBefore);
           

        });

    });
});
