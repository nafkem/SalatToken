import { ethers } from "hardhat";

async function main() {
    
  const TokenMining = await ethers.deployContract("TokenMining"); 
  await TokenMining.waitForDeployment();
  
  const SalatToken = await ethers.deployContract("SalatToken",[TokenMining.target]); 
  await SalatToken.waitForDeployment();

  console.log(
    `SalatToken contract deployed to ${SalatToken.target, TokenMining.target}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
