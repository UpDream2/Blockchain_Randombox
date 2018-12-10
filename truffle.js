module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // for more about customizing your Truffle configuration!
  networks: {
    development: {
      host: "127.0.0.1",
      //cmjeong 2018-12-10   port: 7545, change 7545-> 8545
      port: 8545,
      network_id: "*" // Match any network id
    }
  }
};
