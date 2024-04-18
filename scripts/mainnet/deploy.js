const { ethers, upgrades } = require("hardhat");

LINEA_CHAINID = "59144";
MPETH_TOKEN = "0x48AFbBd342F64EF8a9Ab1C143719b63C2AD81710";
LINEA_BRIDGE = "0x051F1D88f0aF5763fB888eC4378b4D8B29ea3319";

async function main() {
  const [deployer] = await ethers.getSigners();

  const SwapToMpEthOnLinea = await ethers.getContractFactory("SwapToMpEthOnLineaV1");

  // Step 1 - Deploy SwapToMpEthOnLinea
  const ProxyContract = await upgrades.deployProxy(
    SwapToMpEthOnLinea,
    [
      LINEA_CHAINID,
      LINEA_BRIDGE,
      MPETH_TOKEN,
      "0xf1552d1d7CD279A7B766F431c5FaC49A2fb6e361" // META POOL EVM
    ]
  );
  await ProxyContract.waitForDeployment();

  const SwapToMpEthOnLineaV1Implementation = await upgrades.erc1967.getImplementationAddress(ProxyContract.target);
  const adminAddress = await upgrades.erc1967.getAdminAddress(ProxyContract.target);

  // Summary
  console.log("MpEthTokenContract: ", MPETH_TOKEN);
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