let { task } = require("hardhat/config");
let { getSwaps } = require("../scripts/config");

task("deployCore",
    "deploy butter router contract"
)
    .setAction(async (taskArgs, hre) => {
        const { deployments, getNamedAccounts, ethers } = hre;
        const { deploy } = deployments;
        const { deployer } = await getNamedAccounts();

        console.log("deployer :", deployer)

        let result = await deploy('ButterCore', {
            from: deployer,
            args: [],
            log: true,
            contract: 'ButterCore'
        });

        console.log("core deployed to :", result.address);
    })


task("deployUniV2ForkSwap",
    "deployUniV2ForkSwap"
)
    .setAction(async (taskArgs, hre) => {
        const { deployments, getNamedAccounts, ethers } = hre;
        const { deploy } = deployments;
        const { deployer } = await getNamedAccounts();

        console.log("deployer :", deployer)

        let result = await deploy('UniV2ForkSwap', {
            from: deployer,
            args: [],
            log: true,
            contract: 'UniV2ForkSwap'
        });

        console.log("UniV2ForkSwap deployed to :", result.address);
    })

task("deployUniV3ForkSwap",
    "deployUniV3ForkSwap"
)
    .setAction(async (taskArgs, hre) => {
        const { deployments, getNamedAccounts, ethers } = hre;
        const { deploy } = deployments;
        const { deployer } = await getNamedAccounts();

        console.log("deployer :", deployer)

        let result = await deploy('UniV3ForkSwap', {
            from: deployer,
            args: [],
            log: true,
            contract: 'UniV3ForkSwap'
        });

        console.log("UniV3ForkSwap deployed to :", result.address);
    })

task("deployCurveForkSwap",
    "deployCurveForkSwap"
)
    .setAction(async (taskArgs, hre) => {
        const { deployments, getNamedAccounts, ethers } = hre;
        const { deploy } = deployments;
        const { deployer } = await getNamedAccounts();

        console.log("deployer :", deployer)

        let result = await deploy('CurveForkSwap', {
            from: deployer,
            args: [],
            log: true,
            contract: 'CurveForkSwap'
        });

        console.log("CurveForkSwap deployed to :", result.address);
    })

task("setSwapTypeHandle",
    "setSwapTypeHandle"
)
    .setAction(async (taskArgs, hre) => {
        const { deployments, getNamedAccounts, ethers } = hre;
        const { deploy } = deployments;
        const { deployer } = await getNamedAccounts();

        console.log("deployer :", deployer)

        let ButterCore;
        try {
            ButterCore = await deployments.get("ButterCore");
        } catch (error) {

        }

        let Core = await ethers.getContractFactory("ButterCore");
        if (!ButterCore) {
            ButterCore = await deploy('ButterCore', {
                from: deployer,
                args: [],
                log: true,
                contract: 'ButterCore'
            })
        }
        let core = Core.attach(ButterCore.address);
        console.log("butterCore address :", ButterCore.address);
        let UniV2ForkSwap = await deployments.get("UniV2ForkSwap");

        if (UniV2ForkSwap) {
            await (await core.setSwapTypeHandle(1, UniV2ForkSwap.address)).wait();
            console.log("setSwapTypeHandle UniV2ForkSwap");
        }

        let UniV3ForkSwap;

        try {
            UniV3ForkSwap = await deployments.get("UniV3ForkSwap");
        } catch (error) {

        }

        if (UniV3ForkSwap) {
            await (await core.setSwapTypeHandle(2, UniV3ForkSwap.address)).wait();
            console.log("setSwapTypeHandle UniV3ForkSwap");
        }

        let CurveForkSwap;

        try {
            CurveForkSwap = await deployments.get("CurveForkSwap");
        } catch (error) {

        }

        if (CurveForkSwap) {
            await (await core.setSwapTypeHandle(3, CurveForkSwap.address)).wait();
            console.log("setSwapTypeHandle CurveForkSwap");
        }

    })

task("setSwapConfig",
    "setSwapConfig"
)
    .setAction(async (taskArgs, hre) => {
        const { deployments, getNamedAccounts, ethers, network } = hre;
        const { deploy } = deployments;
        const { deployer } = await getNamedAccounts();

        console.log("deployer :", deployer)

        let ButterCore;
        try {
            ButterCore = await deployments.get("ButterCore");
        } catch (error) {

        }
        let Core = await ethers.getContractFactory("ButterCore");
        if (!ButterCore) {
            ButterCore = await deploy('ButterCore', {
                from: deployer,
                args: [],
                log: true,
                contract: 'ButterCore'
            })
        }
        let core = Core.attach(ButterCore.address);
        console.log("butterCore address :", ButterCore.address);
        let swaps = getSwaps(network.name);
        if (swaps && swaps.length > 0)

            for (let i = 0; i < swaps.length; i++) {
                let swap = swaps[i];
                let config = {
                    swapRouter: swap.router,
                    swapType: swap.type
                }
                await (await core.setSwapConfig(swap.index, config)).wait();
                console.log(`set index ${swap.index} for ${swap.name}`);
            }

    })