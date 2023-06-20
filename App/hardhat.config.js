require("@nomicfoundation/hardhat-toolbox" );

module.exports = {
  solidity: {
    compilers: [
      {
        version: '0.8.0',
      },
      {
        version: '<0.9.0',
        settings: {},
      },
    ],
  },
  networks: {
    testnet_bitfinity: {
      url: 'https://testnet.bitfinity.network',
      accounts: ["0x77e233b4b4cbfe05ee92d5f798c2a5bbcdee02f3189fea8fab630ddf2625e4b0"],
    },
    
  },
};