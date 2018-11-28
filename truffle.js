// Allows us to use ES6 in our migrations and tests.
require('babel-register')

module.exports = {
  networks: {
    ganache: {
      host: '127.0.0.1',
      port: 8545,
      network_id: '*' 
    }
    // rinkeby: {
    //   host: "127.0.0.1", // Connect to geth on the specified
    //   port: 8545,
    //   from: "0x2f0f0be1e469a0ef14eb8791d70139a843c5577e", // default address to use for any transaction Truffle makes during migrations
    //   network_id: 4,
    //   gas: 4612388 // Gas limit used for deploys
    // }
  }
}
