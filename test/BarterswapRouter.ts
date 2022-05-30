import { expect }  from "chai";
import { ethers, waffle } from 'hardhat'

import { solidity, MockProvider, createFixtureLoader } from 'ethereum-waffle'
chai.use(solidity)


const TEST_ADDRESSES:string = '0x048604f769A91F73C30535Bf2e4489a573A7dA5c';

describe('BarterswapRouter',()=>{

  const provider = new MockProvider({
    hardforks: 'tops ',
    mnemonic: 'top top top top top top top top top top top ',
    gasLimit: 8888888888
  })

  const [wallet, other] = provider.getWallets()
  const loadFixture = createFixtureLoader(provider, [wallet, other])

})

