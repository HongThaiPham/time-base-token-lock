const hre = require("hardhat");
const dayjs = require("dayjs");

const getContract = async () => {
  const TimeLockedWalletFactory = await hre.ethers.getContractFactory(
    "TimeLockedWalletFactory"
  );
  const contractTimeLockedWalletFactory =
    await TimeLockedWalletFactory.deploy();

  await contractTimeLockedWalletFactory.deployed();

  console.log(
    "TimeLockedWalletFactory deployed to:",
    contractTimeLockedWalletFactory.address
  );

  const TokenLockFactory = await hre.ethers.getContractFactory("TokenLock");
  const contractTokenLock = await TokenLockFactory.deploy();

  await contractTokenLock.deployed();

  console.log("TokenLockFactory deployed to:", contractTokenLock.address);

  return { contractTimeLockedWalletFactory, contractTokenLock };
};

const main = async () => {
  [owner, addr1, addr2, ...addrs] = await ethers.getSigners();
  const unlockDate = dayjs().add(2, "m").unix();

  const { contractTimeLockedWalletFactory, contractTokenLock } =
    await getContract();

  // create wallet locked with token
  const walletFactory = await hre.ethers.getContractFactory("TimeLockedWallet");
  const wallet = await walletFactory.deploy(
    owner.address,
    addr1.address,
    unlockDate
  );
  await wallet.deployed();
  console.log(`Wallet address: ${wallet.address}`);
  await contractTokenLock.transfer(
    wallet.address,
    hre.ethers.utils.parseEther("10"),
    { from: owner.address }
  );

  const balance = await contractTokenLock.balanceOf(wallet.address);
  console.log(`Wallet balance: ${balance}`);

  await wallet.connect(addr1).withdrawTokens(contractTokenLock.address);
};

main();
