const { expect } = require("chai");
const hre = require("hardhat");
describe("ZeeToken contract", function() {
  // global vars
  let Token;
  let ZeeToken;
  let owner;
  let addr1;
  let addr2;
  let tokenCap = 100000000;
  let tokenBlockReward = 50;

  beforeEach(async function () {
    // Get the ContractFactory and Signers here.
    Token = await ethers.getContractFactory("ZeeToken");
    [owner, addr1, addr2] = await hre.ethers.getSigners();

    ZeeToken = await Token.deploy(tokenCap, tokenBlockReward);
  });

  describe("Deployment", function () {
    it("Should set the right owner", async function () {
      expect(await ZeeToken.owner()).to.equal(owner.address);
    });

    it("Should assign the total supply of tokens to the owner", async function () {
      const ownerBalance = await ZeeToken.balanceOf(owner.address);
      expect(await ZeeToken.totalSupply()).to.equal(ownerBalance);
    });

    it("Should set the max capped supply to the argument provided during deployment", async function () {
        const cap = await ZeeToken.cap();
        // You don't need to formatEther for a uint256 value
        expect(cap).to.equal(tokenCap);
      });
      
      it("Should set the blockReward to the argument provided during deployment", async function () {
        const blockReward = await ZeeToken.blockReward();
        // You don't need to formatEther for a uint256 value
        expect(blockReward).to.equal(tokenBlockReward);
      });
      
  });

  describe("Transactions", function () {
    it("Should transfer tokens between accounts", async function () {
      // Transfer 50 tokens from owner to addr1
      await ZeeToken.transfer(addr1.address, 50);
      const addr1Balance = await ZeeToken.balanceOf(addr1.address);
      expect(addr1Balance).to.equal(50);

      // Transfer 50 tokens from addr1 to addr2
      // We use .connect(signer) to send a transaction from another account
      await ZeeToken.connect(addr1).transfer(addr2.address, 50);
      const addr2Balance = await ZeeToken.balanceOf(addr2.address);
      expect(addr2Balance).to.equal(50);
    });

    it("Should fail if sender doesn't have enough tokens", async function () {
      const initialOwnerBalance = await ZeeToken.balanceOf(owner.address);
      // Try to send 1 token from addr1 (0 tokens) to owner (1000000 tokens).
      // `require` will evaluate false and revert the transaction.
      await expect(
        ZeeToken.connect(addr1).transfer(owner.address, 1)
      ).to.be.revertedWith("ERC20: transfer amount exceeds balance");

      // Owner balance shouldn't have changed.
      expect(await ZeeToken.balanceOf(owner.address)).to.equal(
        initialOwnerBalance
      );
    });

    it("Should update balances after transfers", async function () {
      const initialOwnerBalance = await ZeeToken.balanceOf(owner.address);

      // Transfer 100 tokens from owner to addr1.
      await ZeeToken.transfer(addr1.address, 100);

      // Transfer another 50 tokens from owner to addr2.
      await ZeeToken.transfer(addr2.address, 50);

      // Check balances.
      const finalOwnerBalance = await ZeeToken.balanceOf(owner.address);
      expect(finalOwnerBalance).to.equal(initialOwnerBalance.sub(150));

      const addr1Balance = await ZeeToken.balanceOf(addr1.address);
      expect(addr1Balance).to.equal(100);

      const addr2Balance = await ZeeToken.balanceOf(addr2.address);
      expect(addr2Balance).to.equal(50);
    });
  });
  
});