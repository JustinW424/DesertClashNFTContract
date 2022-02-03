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
  
  const Traits = await hre.ethers.getContractFactory("Traits");
  const traits = await Traits.deploy();
  console.log("Temple ------- traits deployed ------- ", traits.address);
  await traits.deployed();
  
  const GOLD = await hre.ethers.getContractFactory("GOLD");
  const gold = await GOLD.deploy();
  console.log("Temple ------- GOLD deployed ------- ", gold.address);
  await gold.deployed();

  // const Pool = await hre.ethers.getContractFactory("Pool");
  // const wallet = await Pool.deploy();
  // console.log("Temple ------- Pool deployed ------- ", gold.address);
  // await wallet.deployed();

  // const Camelit = await hre.ethers.getContractFactory("Camelit");
  // const camelit = await Camelit.deploy();
  // console.log("Temple ------- Pool deployed ------- ", gold.address);
  // await camelit.deployed();

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
