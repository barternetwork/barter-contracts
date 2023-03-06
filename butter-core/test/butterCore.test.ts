import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
import { ethers, network, deployments } from "hardhat";
import { BigNumber, Contract } from "ethers";
import { SignerWithAddress } from "@nomiclabs/hardhat-ethers/signers";

let deployer: SignerWithAddress;

let _user: SignerWithAddress;

let butterCore: Contract;

let uni_v2_router = "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D";

let uni_v3_router = "0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45";

let curve_router = "0x99a58482BD75cbab83b27EC03CA68fF489b5788f";

let usdc_addr = "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48";

let weth = "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2";

let dai_addr = "0x6B175474E89094C44Da98b954EedeAC495271d0F";


let ERC20 = [
    'function approve(address spender, uint256 amount) external returns (bool)',
    'function balanceOf(address account) external view returns (uint256)',
    'function transfer(address to, uint value) external returns (bool)'
]

describe("ButterCore", function () {

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
        let ButterCore = await ethers.getContractFactory('ButterCore');
        butterCore = await ButterCore.deploy(wallet.address);
        await butterCore.connect(wallet).deployed();

        let CurveForkSwap = await ethers.getContractFactory('CurveForkSwap');
        let curveForkSwap = await CurveForkSwap.deploy();
        await curveForkSwap.connect(wallet).deployed();

        let UniV2ForkSwap = await ethers.getContractFactory('UniV2ForkSwap');

        let uniV2ForkSwap = await UniV2ForkSwap.deploy();

        await uniV2ForkSwap.connect(wallet).deployed();

        let UniV3ForkSwap = await ethers.getContractFactory('UniV3ForkSwap');

        let uniV3ForkSwap = await UniV3ForkSwap.deploy();

        await uniV3ForkSwap.connect(wallet).deployed();

        await (await butterCore.setSwapTypeHandle(1, uniV2ForkSwap.address)).wait();

        await (await butterCore.setSwapTypeHandle(2, uniV3ForkSwap.address)).wait();

        await (await butterCore.setSwapTypeHandle(3, curveForkSwap.address)).wait();
        // struct SwapConfig{
        //     address swapRouter;
        //     uint256 swapType; // 1 - univ2, 2 - univ3, 3 - curve  
        // }
        let config = {
            swapRouter: uni_v2_router,
            swapType: 1
        }
        await (await butterCore.setSwapConfig(0, config)).wait();

        config = {
            swapRouter: uni_v3_router,
            swapType: 2
        }

        await (await butterCore.setSwapConfig(1, config)).wait();

        config = {
            swapRouter: curve_router,
            swapType: 3
        }

        await (await butterCore.setSwapConfig(2, config)).wait();
    }


    describe("butterCore", function () {


        it("butter -> multiSwap in tokens ", async function () {

            let [wallet, other] = await ethers.getSigners();

            await loadFixture(deployFixture);

            let amountIn = ethers.utils.parseEther("2000");
            let deadLines = Math.floor(Date.now() / 1000) + 60 * 20;
            let amountOutMin = 0;
            let to = wallet.address;
            let path = [dai_addr, usdc_addr];
            let inputAddre = dai_addr;
            let outAddre = usdc_addr;
            let v2Data = ethers.utils.defaultAbiCoder.encode(['uint256', 'uint256', 'address[]', 'address', 'uint256', 'address', 'address'], [amountIn, amountOutMin, path, to, deadLines, inputAddre, outAddre]);


            let v3_amountIn = ethers.utils.parseEther("2000");
            let v3_amountOutMin = 0;
            let v3_to = wallet.address;
            let v3_path = "0x6B175474E89094C44Da98b954EedeAC495271d0F000bb8A0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48";
            let v3_inputAddre = dai_addr;
            let v3_outAddre = usdc_addr;
            let v3_data = ethers.utils.defaultAbiCoder.encode(['uint256', 'uint256', 'bytes', 'address', 'address', 'address'], [v3_amountIn, v3_amountOutMin, v3_path, v3_to, v3_inputAddre, v3_outAddre]);


            let amount = ethers.utils.parseEther("2000");
            let expected = 0;
            let receiver = wallet.address;
            let route = [dai_addr, "0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7", usdc_addr, "0x0000000000000000000000000000000000000000", "0x0000000000000000000000000000000000000000", "0x0000000000000000000000000000000000000000", "0x0000000000000000000000000000000000000000", "0x0000000000000000000000000000000000000000", "0x0000000000000000000000000000000000000000"];
            let input = dai_addr;
            let swap_params = [[0, 1, 1], [0, 0, 0], [0, 0, 0], [0, 0, 0]];
            let pools = ["0x0000000000000000000000000000000000000000", "0x0000000000000000000000000000000000000000", "0x0000000000000000000000000000000000000000", "0x0000000000000000000000000000000000000000"]
            let curve_data = ethers.utils.defaultAbiCoder.encode(['address', 'address[9]', 'uint256[3][4]', 'uint256', 'uint256', 'address[4]', 'address'], [input, route, swap_params, amount, expected, pools, receiver]);
            // struct AccessParams {
            //     uint256[] amountInArr;
            //     bytes[] paramsArr;
            //     uint32[] routerIndex;
            //     address[2] inputOutAddre;  // 0 -input  1- Out
            // }
            let dai = await ethers.getContractAt(ERC20, dai_addr, _user);
            await (await dai.approve(butterCore.address, ethers.utils.parseEther("10000000"))).wait();
            let usdc = await ethers.getContractAt(ERC20, usdc_addr, wallet);
            let balanceBefore = await usdc.balanceOf(wallet.address);
            let param = {
                amountInArr: [amountIn, v3_amountIn, amount],
                paramsArr: [v2Data, v3_data, curve_data],
                routerIndex: [0,1, 2],
                inputOutAddre: [dai_addr, usdc_addr]
            }
            await butterCore.connect(_user).multiSwap(param);

            let balanceAfter = await usdc.balanceOf(wallet.address);

            expect(balanceAfter).gt(balanceBefore);
        });

        it("butter -> multiSwap in eth ", async function () {
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


            let v3_amountIn = ethers.utils.parseEther("2");
            let v3_amountOutMin = 0;
            let v3_to = wallet.address;
            let v3_path = "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2000bb8A0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48";
            let v3_inputAddre = ethers.constants.AddressZero;
            let v3_outAddre = usdc_addr;
            let v3_data = ethers.utils.defaultAbiCoder.encode(['uint256', 'uint256', 'bytes', 'address', 'address', 'address'], [v3_amountIn, v3_amountOutMin, v3_path, v3_to, v3_inputAddre, v3_outAddre]);


            let amount = ethers.utils.parseEther("2");
            let expected = 0;
            let receiver = wallet.address;
            let route = ["0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE", "0xD51a44d3FaE010294C616388b506AcdA1bfAAE46", "0xdAC17F958D2ee523a2206206994597C13D831ec7", "0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7", usdc_addr, "0x0000000000000000000000000000000000000000", "0x0000000000000000000000000000000000000000", "0x0000000000000000000000000000000000000000", "0x0000000000000000000000000000000000000000"];
            let input = ethers.constants.AddressZero;
            let swap_params = [[2, 0, 3], [2, 1, 1], [0, 0, 0], [0, 0, 0]];
            let pools = ["0x0000000000000000000000000000000000000000", "0x0000000000000000000000000000000000000000", "0x0000000000000000000000000000000000000000", "0x0000000000000000000000000000000000000000"]
            let curve_data = ethers.utils.defaultAbiCoder.encode(['address', 'address[9]', 'uint256[3][4]', 'uint256', 'uint256', 'address[4]', 'address'], [input, route, swap_params, amount, expected, pools, receiver]);
            // struct AccessParams {
            //     uint256[] amountInArr;
            //     bytes[] paramsArr;
            //     uint32[] routerIndex;
            //     address[2] inputOutAddre;  // 0 -input  1- Out
            // }
            let usdc = await ethers.getContractAt(ERC20, usdc_addr, wallet);
            let balanceBefore = await usdc.balanceOf(wallet.address);
            let param = {
                amountInArr: [amountIn, v3_amountIn, amount],
                paramsArr: [data, v3_data, curve_data],
                routerIndex: [0,1,2],
                inputOutAddre: [ethers.constants.AddressZero, usdc_addr]
            }
            await (await butterCore.connect(_user).multiSwap(param, { value: ethers.utils.parseEther("6") })).wait();

            let balanceAfter = await usdc.balanceOf(wallet.address);

            expect(balanceAfter).gt(balanceBefore);

        });

    });
});

