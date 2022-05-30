import { expect }  from "chai";
import { ethers, waffle } from 'hardhat'
import { Bytes, Contract } from 'ethers'
import { AddressZero } from 'ethers/constants'

import { solidity, MockProvider,createFixtureLoader } from 'ethereum-waffle'
import { AlchemyWebSocketProvider } from "@ethersproject/providers";

chai.use(solidity)


const TEST_ADDRESSES:string = '0x7000000000000000000000000000000000000000';

let setFeeToSetter:string = '0x3044BED7679b031CCbefEC054FdA9aD350D372B4';

let toFess:number = 0.2*10*16;

describe('BarterswapRouter',()=>{

  const provider = new MockProvider({
    hardforks: 'tops',
    mnemonic: 'top top top top top top top top top top top ',
    gasLimit: 8888888888
  })

  const [wallet, other] = provider.getWallets()
  const loadFixture = createFixtureLoader(provider, [wallet, other])

  let roter: Contract
   
  it('setFeeTo, setFeeToSetter,setFees', async () => {
    expect(await roter.setFeeTo()).to.eq(wallet.address)
    expect(await roter.setFeeToSetter()).to.eq(setFeeToSetter)
    expect(await roter.setFees()).to.eq(toFess)
  })


type AccessParams = {
  amountInArr:Array<number>;
  amountOutMinArr:Array<number>;
  pathArr:Array<Bytes>;
  to:string;
  deadLine:number;
  inputAddre:string;
  outAddre:string;
  routerIndex:Array<number>
}
  async function multiSwaps(Params:AccessParams) {
    expect(await roter.multiSwap(Params)).to.eq(AddressZero);
  }


  it('setFeeTo', async () => {
    await expect(roter.connect(other).setFeeTo(other.address)).to.be.revertedWith('Barterswap: FORBIDDEN');
    await roter.setFeeTo(wallet.address);
    expect(await roter.feeTo()).to.eq(wallet.address);
  })

  

  it('setFeeToSetter', async () => {
    await expect(roter.connect(other).setFeeToSetter(other.address)).to.be.revertedWith('Barterswap: FORBIDDEN');
    await roter.setFeeToSetter(other.address);
    expect(await roter.feeToSetter()).to.eq(other.address);
    await expect(roter.setFeeToSetter(wallet.address)).to.be.revertedWith('Barterswap: FORBIDDEN');
  })

})

