# ccid

[![pub version](https://img.shields.io/pub/v/ccid)](https://pub.dev/packages/ccid)
[![Build Example App](https://github.com/nfcim/ccid/actions/workflows/example-app.yaml/badge.svg)](https://github.com/nfcim/ccid/actions/workflows/example-app.yaml)

A Flutter plugin for reading and writing smart cards using the CCID protocol with PC/SC-like APIs.

## Installation


### Linux

This plugin uses `dart_pcsc`, thus has a runtime dependency on [`PCSCLite`](https://pcsclite.apdu.fr/):

* Debian / Ubuntu: `sudo apt-get install pcscd libpcsclite1`
* RHEL / Fedora: `sudo dnf install pcsc-lite`

Should you encounter any permission problem, please check [README.polkit](https://github.com/LudovicRousseau/PCSC/blob/master/doc/README.polkit) from PCSCLite.

