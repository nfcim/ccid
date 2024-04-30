# flutter_ccid

[![Build Example App](https://github.com/nfcim/flutter_ccid/actions/workflows/example-app.yaml/badge.svg)](https://github.com/nfcim/flutter_ccid/actions/workflows/example-app.yaml)

A Flutter plugin for reading and writing smart cards using the CCID protocol with PC/SC-like APIs.

## Installation

### Android

TODO: USB permission?

### Linux

This plugin uses `dart_pcsc`, thus has a runtime dependency on `pcsc-lite`: `sudo apt-get install pcscd libpcsclite1`.
