// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  
  const CakeLP = await hre.ethers.getContractFactory("Traits");
  const cake = await CakeLP.deploy();
  console.log("Temple ------- CakeLP deployed ------- ", cake.address);
  await cake.deployed();
  
  // const ETB = await hre.ethers.getContractFactory("ETBToken");
  // const etb = await ETB.deploy();
  // console.log("Temple ------- CakeLP deployed ------- ", etb.address);
  // await etb.deployed();

  // const Wallet = await hre.ethers.getContractFactory("Wallet");
  // const wallet = await Wallet.deploy("0xB56CDe5115457715d326eA961E78d3aeD61be592");
  // await wallet.deployed();

  // console.log("wallet deployed to:", wallet.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
