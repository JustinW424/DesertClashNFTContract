const { expect } = require("chai");
const { ethers } = require("hardhat");
describe("Camelit : ", function () {
  it("Camelit is deployed for the unit-test", async function () {
    const Camel = await ethers.getContractFactory("Camelit");
    const camel = await Camel.deploy();
    await camel.deployed();

    expect(
      await camel.mint(1, 0)
    ).to.equal("1000000000000000000000000");
    console.log(etb.address, ": ETB contract deployed on it.");
  });
});

// describe("CakeLP : ", function () {
//   it("CakeLP is deployed as below", async function () {
//     const CakeLP = await ethers.getContractFactory("CakeLP");
//     const cake = await CakeLP.deploy();
//     await cake.deployed();

//     console.log(cake.address, ": CakeLP contract deployed on it.");
//     await cake.approve("0x0165878A594ca255338adfa4d48449f69242Eb8F", 2000)
//     await cake.approve("0xDc64a140Aa3E981100a9becA4E685f962f0cF6C9", 5000)

    
//     expect(
//       await cake.balanceOf("0xf39fd6e51aad88f6f4ce6ab8827279cfffb92266")
//     ).to.equal("100000000000000000000");

//   });

// });

// describe("Wallet : ", function () {
//   it("Should return the current User's wallet balance : ", async function () {
//     const Wallet = await ethers.getContractFactory("Wallet");
//     const wallet = await Wallet.deploy("0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512");
//     await wallet.deployed();
//     console.log(wallet.address, ": Wallet Contract deployed on it.");
//     const deposit_tx = await wallet.deposit(300);
//     console.log(deposit_tx, ": User deposited CakeLPToken to Wallet");
//     expect(
//       await wallet.getBalance()
//     ).to.equal(300);

//   });
// });

// describe("StakingPool : ", function () {
//   it("StakingPool should return : ", async function () {
//     const StakingPool = await ethers.getContractFactory("StakingPool");
//     const stakingpool = await StakingPool.deploy("0x5FbDB2315678afecb367f032d93F642f64180aa3", "0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512");
//     await stakingpool.deployed();
//     console.log(stakingpool.address, ": stakingpool Contract deployed on it.");

//     expect(
//       await stakingpool.getBalance()
//     ).to.equal(0);
//     await stakingpool.depositAndStartStake(500)

//     expect(
//       await stakingpool.totalStakes()
//     ).to.equal(500);
//     expect(
//       await stakingpool.getStakedBalance()
//     ).to.equal(500);
//   });
// });
