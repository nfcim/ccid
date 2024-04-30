import 'package:platform_detector/platform_detector.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_ccid.dart';
import 'flutter_ccid_method_channel.dart';
import 'flutter_ccid_pcsc.dart';

abstract class FlutterCcidPlatform extends PlatformInterface {
  /// Constructs a FlutterCcidPlatform.
  FlutterCcidPlatform() : super(token: _token);

  static final Object _token = Object();

  static final FlutterCcidPlatform _methodChannelInstance =
      MethodChannelFlutterCcid();

  static final FlutterCcidPlatform _pcscInstance = PcscFlutterCcid();

  /// The default instance of [FlutterCcidPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterCcid].
  static FlutterCcidPlatform get instance {
    if (isMobile() || isMacOs()) {
      return _methodChannelInstance;
    } else {
      return _pcscInstance;
    }
  }

  Future<List<String>> listReaders() {
    throw UnimplementedError('poll() has not been implemented.');
  }

  Future<String?> transceive(String reader, String capdu) {
    throw UnimplementedError('transceive() has not been implemented.');
  }

  Future<FlutterCcidCard> connect(String reader) {
    throw UnimplementedError('connect() has not been implemented.');
  }

  Future<void> disconnect(String reader) {
    throw UnimplementedError('disconnect() has not been implemented.');
  }
}
