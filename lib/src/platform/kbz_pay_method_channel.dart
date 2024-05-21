import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'kbz_pay_platform_interface.dart';
import '../entities/entities.dart';

/// An implementation of [KBZPayPlatform] that uses method channels.
class MethodChannelKBZPay extends KBZPayPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('kbz_pay');

  @override
  Future<void> startPay(PaymentRequestModel request) async {
    await methodChannel.invokeMethod(
      "startPay",
      request.toJson(),
    );
  }
}
