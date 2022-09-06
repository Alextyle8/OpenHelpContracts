async function main() {
    const OpenHelp = await ethers.getContractFactory("OpenHelp")
  
    // Start deployment, returning a promise that resolves to a contract object
    const openHelp = await OpenHelp.deploy()
    await openHelp.deployed()
    console.log("Contract deployed to address:", openHelp.address)
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error)
      process.exit(1)
    })
  