import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_ccid.dart';
import 'flutter_ccid_method_channel.dart';

abstract class FlutterCcidPlatform extends PlatformInterface {
  /// Constructs a FlutterCcidPlatform.
  FlutterCcidPlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterCcidPlatform _instance = MethodChannelFlutterCcid();

  /// The default instance of [FlutterCcidPlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterCcid].
  static FlutterCcidPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterCcidPlatform] when
  /// they register themselves.
  static set instance(FlutterCcidPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
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
