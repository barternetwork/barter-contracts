//type 1 - uni_v2_fork  2 - uni_v3_fork  3 curve_fork
let mainnet_config = {
    bsc: [{
        name: "PancakeSwap",
        type: 1,
        router: "0x10ED43C718714eb63d5aA57B78B54704E256024E",
        index: 0
    },
    {
        name: "SushiSwap",
        type: 1,
        router: "0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506",
        index: 1
    }
   ],
    eth: [{
        name: "uniV2",
        type: 1,
        router: "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D",
        index: 0
    },
    {
        name: "SushiSwap",
        type: 1,
        router: "0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F",
        index: 1
    },
    {
        name: "uniV3",
        type: 2,
        router: "0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45",
        index: 2
    },
    {
        name: "curve",
        type: 3,
        router: "0x99a58482BD75cbab83b27EC03CA68fF489b5788f",
        index: 3
    }
],
    matic: [{
        name: "QuickSwap",
        type: 1,
        router: "0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff",
        index: 0
    },
    {
        name: "SushiSwap",
        type: 1,
        router: "0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506",
        index: 1
    },
    {
        name: "uniV3",
        type: 2,
        router: "0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45",
        index: 2
    },
    {
        name: "curve",
        type: 3,
        router: "0x2a426b3Bb4fa87488387545f15D01d81352732F9",
        index: 3
    }]
}

let testnet_config = {
    bsc: [{
        name: "uniV2",
        type: 1,
        router: "0xD99D1c33F9fC3444f8101754aBC46c52416550D1",
        index: 0
    },
    {
        name: "SushiSwap",
        type: 1,
        router: "0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506",
        index: 1
    }
],
    eth: [{
        name: "uniV2",
        type: 1,
        router: "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D",
        index: 0
    },
    {
        name: "SushiSwap",
        type: 1,
        router: "0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506",
        index: 1
    },
    {
        name: "uniV3",
        type: 2,
        router: "0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45",
        index: 2
    }],
    matic: [{
        name: "QuickSwap",
        type: 1,
        router: "0xa5E0829CaCEd8fFDD4De3c43696c57F7D7A678ff",
        index: 0
    },
    {
        name: "SushiSwap",
        type: 1,
        router: "0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506",
        index: 1
    },
    {
        name: "uniV3",
        type: 2,
        router: "0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45",
        index: 2
    }]
}
// dev 
// let testnet_config = {
//     bsc: [{
//         name: "uniV2",
//         type: 1,
//         router: "0x6710b000cc6728e068C095B66535E1A8b552e816",
//         index: 0
//     }
   
// ],
//     eth: [{
//         name: "uniV2",
//         type: 1,
//         router: "0xa064aa3f10de46cb114e543a9f8d90770cfb0d7c",
//         index: 0
//     }],
//     matic: [{
//         name: "QuickSwap",
//         type: 1,
//         router: "0x15e6c86a9ac9a32f91125794fda82eeb807ed818",
//         index: 0
//     }]
// }

export function getSwaps(network: string) {
    let s = network.split("_");

    if (s.length != 2) {
        return [];
    }

    if (s[1] === "mainnet") {
        if (s[0] === "bsc") {
            return mainnet_config.bsc;
        } else if (s[0] === "eth") {
            return mainnet_config.eth;
        } else if (s[0] === "matic") {
            return mainnet_config.matic;
        }
        return []
    } else {
        if (s[0] === "bsc") {
            return testnet_config.bsc;
        } else if (s[0] === "eth") {
            return testnet_config.eth;
        } else if (s[0] === "matic") {
            return testnet_config.matic;
        }
        return []
    }
}  