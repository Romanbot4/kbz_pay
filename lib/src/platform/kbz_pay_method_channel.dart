import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'kbz_pay_platform_interface.dart';
import '../entities/entities.dart';

/// An implementation of [KBZPayPlatform] that uses method channels.
class MethodChannelKBZPay extends KBZPayPlatform {
  MethodChannelKBZPay() {
    _paymentStatusStream = eventChannel.receiveBroadcastStream();
  }

  /// The method channel used to interact with the native platform.
  @visibleForTesting
  late final methodChannel = const MethodChannel('kbz_pay');

  @visibleForTesting
  late final eventChannel = const EventChannel("kbz_pay_event");

  Stream<dynamic>? _paymentStatusStream;
  
  @override
  void addPaymentStatusListener() {
    _paymentStatusStream?.listen((data) {
      log("Romanbot4 - Received data $data");
    });
  }

  @override
  Future<void> startPay(PaymentRequestModel request) async {
    await methodChannel.invokeMethod(
      "startPay",
      request.toJson(),
    );
  }
}
