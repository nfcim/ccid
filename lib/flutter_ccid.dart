import 'flutter_ccid_platform_interface.dart';

class FlutterCcid {
  // List readers
  Future<List<String>> listReaders() {
    return FlutterCcidPlatform.instance.listReaders();
  }

  // Connect to a card
  Future<FlutterCcidCard> connect(String reader) {
    return FlutterCcidPlatform.instance.connect(reader);
  }
}

class FlutterCcidCard {
  final String reader;

  FlutterCcidCard(this.reader);

  // Send APDU command
  Future<String?> transceive(String capdu) {
    return FlutterCcidPlatform.instance.transceive(reader, capdu);
  }

  // Disconnect from the card
  Future<void> disconnect() {
    return FlutterCcidPlatform.instance.disconnect(reader);
  }
}
