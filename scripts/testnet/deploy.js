const { ethers, upgrades } = require("hardhat");

// MPETH_TOKEN_SEPOLIA = 0x92036c557d88Bd7749BCAA9CA41f3EE8f1E21a29;

async function main() {
  const [deployer] = await ethers.getSigners();

  const MpEthToken = await ethers.getContractFactory("MpEthToken");
  const SwapToMpEthOnLinea = await ethers.getContractFactory("SwapToMpEthOnLinea");

  // Step 1 - Deploy mpETH token
  // const MpDaoTokenContract = await ethers.getContractAt("MpDaoToken", MPETH_TOKEN_SEPOLIA);
  // const MpEthTokenContract = await MpEthToken.connect(deployer).deploy(
  //   "Meta Pool ETH",
  //   "mpETH"
  // );
  // await MpEthTokenContract.waitForDeployment();

  // Step 2 - Deploy SwapToMpEthOnLinea
  const ProxyContract = await upgrades.deployProxy(
    SwapToMpEthOnLinea,
    [MpDaoTokenContract.target]
  );
  await ProxyContract.waitForDeployment();

  const VotingPowerV1Implementation = await upgrades.erc1967.getImplementationAddress(ProxyContract.target);
  const adminAddress = await upgrades.erc1967.getAdminAddress(ProxyContract.target);
  // const SwapToMpEthOnLineaContract = await SwapToMpEthOnLinea.connect(deployer).deploy(
  // //   "59141", // Chain Id Sepolia Linea

  // // );
  // // await SwapToMpEthOnLineaContract.waitForDeployment();

  // Summary
  // console.log("MpEthTokenContract: ", MpEthTokenContract.target);
  console.log("ProxyAdminContract: ", adminAddress);
  // console.log("ProxyContract:      ", ProxyContract.target);
  // console.log("VotingPowerV1 impl: ", VotingPowerV1Implementation);
  // console.log("DAO OWNER MINTER:   ", mpDaoOwner.address);
  // console.log("DAO OWNER UPGRADE:  ", mpDaoOwner.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});