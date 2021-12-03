# EOSIO Development Node Docker [![Publish](https://github.com/qryio/eosio-dev/actions/workflows/publish.yml/badge.svg)](https://github.com/qryio/eosio-dev/actions/workflows/publish.yml)

This docker image configures a nodeos (v2.1.0) node, for development purposes, by performing the [BIOS Boot Sequence](https://developers.eos.io/welcome/v2.1/tutorials/bios-boot-sequence) and creating an account named `accountnum11`. The development wallet's keys can be found [here](eosio-wallet/secrets.json).

## Usage

```bash
$ docker run -d -p 8080:8080 -p 8888:8888 qryio/eosio-dev 
```

Boot sequence is complete once logs shows `BOOT_SEQUENCE_COMPLETE`

## License

Code and documentation released under [Apache License 2.0](LICENSE)