readme

1.deploy ButterCore

```
npx hardhat deployCore --network <network>
```

deploy UniV2ForkSwap

```
npx hardhat deployUniV2ForkSwap --network <network>
```

deploy deployUniV3ForkSwap

```
npx hardhat deployUniV3ForkSwap --network <network>
```

deploy deployCurveForkSwap

```
npx hardhat deployCurveForkSwap --network <network>
```

3.setSwapTypeHandle （This one adds the undeployed swapFork based on the previous deployment）

```
npx hardhat setSwapTypeHandle --network <network>
```

4.setSwapConfig  (This section is based on the configuration in the config file)

```
npx hardhat setSwapConfig --network <network>
```

5.setSwapTypeHandleSingle   type 1 - univ2  2 - univ3 3 - curve

```
npx hardhat setSwapTypeHandleSingle --type <type> --network <network>
```

4.setSwapConfigSingle  type   index   router - the router address of dex  index start from 0

```
npx hardhat setSwapConfigSingle --index <index> --type <type> --router <router> --network <network>
```
