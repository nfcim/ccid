import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_ccid.dart';
import 'flutter_ccid_platform_interface.dart';

/// An implementation of [FlutterCcidPlatform] that uses method channels.
class MethodChannelFlutterCcid extends FlutterCcidPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_ccid');

  @override
  Future<List<String>> listReaders() async {
    final result = await methodChannel.invokeListMethod<String>('listReaders');
    return result ?? [];
  }

  @override
  Future<FlutterCcidCard> connect(String reader) {
    return methodChannel.invokeMethod('connect', reader).then((value) => FlutterCcidCard(reader));
  }

  @override
  Future<String?> transceive(String reader, String capdu) async {
    final result = await methodChannel.invokeMethod<String>('transceive', <String, dynamic>{
      'reader': reader,
      'capdu': capdu,
    });
    return result;
  }

  @override
  Future<void> disconnect(String reader) {
    return methodChannel.invokeMethod('disconnect', reader);
  }
}
