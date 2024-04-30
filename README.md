# flutter_ccid

A Flutter plugin for reading and writing smart cards using the CCID protocol with PC/SC-like APIs.

## Installation

1. Add `flutter_ccid` as a dependency in your `pubspec.yaml` file
2. Run `flutter pub get`.
3. (For Linux target) Install `pcsc-lite`: `sudo apt-get install pcscd libpcsclite1`.
4. (For Linux / Windows target, **IMPORTANT**): Remove `flutter_ccid` from `FLUTTER_PLUGIN_LIST` in `linux/flutter/generated_plugins.cmake` and/or `windows/flutter/generated_plugins.cmake` since we use pure dart code on these platforms.
