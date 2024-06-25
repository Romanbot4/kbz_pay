import 'kbz_pay_impl.dart';

abstract interface class KBZPay {
  factory KBZPay() => KBZPayImplementation();

  /// Easy to use method if you don't want to precreate order yourself and all 
  /// signining & encyption step.
  /// This will
  /// 1. precreate order
  /// 2. start pay
  /// automatically
  Future<void> easyPay({
    required String merchantCode,
    required String appId,
    required String signKey,
    required String orderId,
    required double amount,
    required String title,
    required String notifyUrl,
    required String callbackInfo,
    /// Only required for iOS.
    required String appScheme,
    required bool isProduction,
  });

  /// Method exposed directly from KbzPay SDK. This should be use if you
  /// already called precreate pay API & received the prepayId from response
  Future<void> startPay({
    required String orderInfo,
    required String sign,
    required String signType,
    required String appScheme,
  });

  void addPaymentStatusListener();
}
