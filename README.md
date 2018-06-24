# EOS-Test-Cave

Automated EOS Testing scripts.

These are only first steps in creating test scripts scenarios.

## Dependencies

The test runner requires `jq` and `bc`.

## Setup

```console
cd ~
git clone https://github.com/EOS-BP-Developers/EOS-Test-Cave.git
cd EOS-Test-Cave
cp -r ./node ~/test
cd wallet && ./start.sh
```

Run tests with `./start.sh`, located in the `EOS-Test-Cave` directory
