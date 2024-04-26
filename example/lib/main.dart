import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_ccid/flutter_ccid.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _flutterCcidPlugin = FlutterCcid();

  Future<void> poll() async {
    try {
      var readers = await _flutterCcidPlugin.listReaders();
      var reader = readers[0];
      print(reader);
      var card = await _flutterCcidPlugin.connect(reader);
      // select fido applet
      var rapdu = await card.transceive("00A4040008A0000006472F0001");
      print(rapdu);
      rapdu = await card.transceive("00A4040008A0000006472F0001");
      print(rapdu);
      await card.disconnect();
    } on PlatformException {
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: poll,
            ),],
        ),
        body: const Center(
          child: Text('Running...'),
        ),
      ),
    );
  }
}
