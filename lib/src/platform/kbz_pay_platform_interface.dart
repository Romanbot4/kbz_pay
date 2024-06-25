import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../entities/start_pay_request_entity.dart';
import 'kbz_pay_method_channel.dart';

abstract class KBZPayPlatform extends PlatformInterface {
  /// Constructs a KBZPayPlatform.
  KBZPayPlatform() : super(token: _token);

  static final Object _token = Object();

  static KBZPayPlatform _instance = MethodChannelKBZPay();

  /// The default instance of [KBZPayPlatform] to use.
  ///
  /// Defaults to [MethodChannelKBZPay].
  static KBZPayPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [KBZPayPlatform] when
  /// they register themselves.
  static set instance(KBZPayPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  void addPaymentStatusListener() {
    throw UnimplementedError();
  }

  Future<void> startPay(PaymentRequestModel request) {
    throw UnimplementedError();
  }
}
