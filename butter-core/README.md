readme

1.deploy ButterCore

```
npx hardhat deployCore --network <network>
```

2.

deploy UniV2ForkSwap (按照需要部署)

```
npx hardhat deployUniV2ForkSwap --network <network>
```

deploy deployUniV3ForkSwap(按照需要部署)

```
npx hardhat deployUniV3ForkSwap --network <network>
```

deploy deployCurveForkSwap(按照需要部署)

```
npx hardhat deployCurveForkSwap --network <network>
```

3.setSwapTypeHandle （这一部会根据上一步部署的swapFork来添加未部署的就不会添加）

```
npx hardhat setSwapTypeHandle --network <network>
```

4.setSwapConfig  这一部会根据config文件配置的内容设置

```
npx hardhat setSwapConfig --network <network>
```
