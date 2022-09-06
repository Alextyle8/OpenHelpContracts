/**
* @type import('hardhat/config').HardhatUserConfig
*/
require('dotenv').config();
require("@nomiclabs/hardhat-ethers");
const { RINKEBY_API_URL, RINKEBY_PRIVATE_KEY, ETH_NETWORK} = process.env;
module.exports = {
   solidity: "0.8.1",
   defaultNetwork: ETH_NETWORK,
   networks: {
      hardhat: {},
      rinkeby: {
        url: "https://eth-rinkeby.alchemyapi.io/v2/f2pQ1mSZrbQxzbhgYsxQvDskNWV8Ozsb",
        accounts: [`0x5a179b1752cf9d6a25ede5387460453b252992e6f55d06c2dfa453969502f4d6`]
     }
   },
}