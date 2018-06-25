# EOS-Test-Cave

Automated EOS Testing scripts.

## Dependencies

The test runner requires `jq` and `bc`.

### Ubuntu

```console
sudo apt-get install -y jq bc
```

## Install

```console
git clone https://github.com/EOS-BP-Developers/EOS-Test-Cave.git
```

## Config

Use the dist:

```console
cp config.json.dist config.json
```

And point the `node_bin` to your local install.

## Running Tests

In the root project directory, tests are executed with:

```console
./start.sh
```
