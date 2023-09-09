const hre = require("hardhat");

async function main() {
  const ZeeToken = await hre.ethers.getContractFactory("ZeeToken");
  const zeeToken = await ZeeToken.deploy(100000000, 50);

  await zeeToken.deploymentTransaction();

  console.log("ZeeToken Token deployed at address:", zeeToken);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
