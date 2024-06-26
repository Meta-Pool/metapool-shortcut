const { ethers, upgrades } = require("hardhat");

LINEA_CHAINID_SEPOLIA = "59141";
MPETH_TOKEN_SEPOLIA = "0xB9860E8552F14Dc81ba08F2251d88179FAf81Ef5";
LINEA_BRIDGE_SEPOLIA = "0x5a0a48389bb0f12e5e017116c1105da97e129142";

async function main() {
  const [deployer] = await ethers.getSigners();

  const MpEthToken = await ethers.getContractFactory("MpEthToken");
  const SwapToMpEthOnLinea = await ethers.getContractFactory("SwapToMpEthOnLineaV1");

  // Step 1 - Deploy mpETH token
  // const MpDaoTokenContract = await ethers.getContractAt("MpDaoToken", MPETH_TOKEN_SEPOLIA);
  // const MpEthTokenContract = await MpEthToken.connect(deployer).deploy(
  //   "Meta Pool ETH",
  //   "mpETH01"
  // );
  // await MpEthTokenContract.waitForDeployment();
  // console.log("MPETH TOKEN MOCK: ", MpEthTokenContract.target);


  // Step 2 - Deploy SwapToMpEthOnLinea
  const ProxyContract = await upgrades.deployProxy(
    SwapToMpEthOnLinea,
    [
      LINEA_CHAINID_SEPOLIA,
      LINEA_BRIDGE_SEPOLIA,
      MPETH_TOKEN_SEPOLIA,
      deployer.address
    ]
  );
  await ProxyContract.waitForDeployment();

  const SwapToMpEthOnLineaV1Implementation = await upgrades.erc1967.getImplementationAddress(ProxyContract.target);
  const adminAddress = await upgrades.erc1967.getAdminAddress(ProxyContract.target);

  // Summary
  console.log("MpEthTokenContract: ", MPETH_TOKEN_SEPOLIA);
  console.log("ProxyAdminContract: ", adminAddress);
  console.log("ProxyContract:      ", ProxyContract.target);
  console.log("SwapToMpEthOnLineaV1 impl: ", SwapToMpEthOnLineaV1Implementation);
  console.log("DAO OWNER UPGRADE:  ", deployer.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});