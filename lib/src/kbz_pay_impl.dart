import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

import 'entities/entities.dart';
import 'platform/platform.dart';
import 'helpers/helpers.dart';
import 'kbz_pay.dart';

class KBZPayImplementation implements KBZPay {
  final KBZPayPlatform _platform;
  KBZPayImplementation([KBZPayPlatform? platform])
      : _platform = platform ?? MethodChannelKBZPay();

  @override
  Future<void> startPay({
    required String orderInfo,
    required String sign,
    required String signType,
    required String appScheme,
  }) async {
    await _platform.startPay(PaymentRequestModel(
      orderInfo: orderInfo,
      sign: sign,
      signType: signType,
      appScheme: appScheme,
    ));
  }

  Future<Map<String, dynamic>> precreatePay({
    required String merchantCode,
    required String appId,
    required String signKey,
    required String orderId,
    required double amount,
    required String title,
    required String notifyUrl,
    required String callbackInfo,
    bool isProduction = false,
  }) async {
    final nounceString = _createRandomString();
    final timeStamp = _createTimeStamp();

    final payload = generatePrecreateOrderRequsetBody(
      merchantCode: merchantCode,
      appId: appId,
      signKey: signKey,
      orderId: orderId,
      amount: amount,
      title: title,
      notifyUrl: notifyUrl,
      callbackInfo: callbackInfo,
      nounceString: nounceString,
      timeStamp: timeStamp,
    );

    final res = await http.post(
      Uri.parse(
        isProduction
            ? "https://api.kbzpay.com/payment/gateway/precreate"
            : "http://api.kbzpay.com/payment/gateway/uat/precreate",
      ),
      body: payload,
    );

    final prepayRes = jsonDecode(res.body)["Response"] as Map<String, dynamic>;
    if (prepayRes["result"] == "FAIL") {
      throw prepayRes;
    }

    return prepayRes;
  }

  @override
  Future<void> easyPay({
    required String merchantCode,
    required String appId,
    required String signKey,
    required String orderId,
    required double amount,
    required String title,
    required String notifyUrl,
    required String callbackInfo,
    required String appScheme,
    required bool isProduction,
  }) async {
    final prepayRes = await precreatePay(
      merchantCode: merchantCode,
      appId: appId,
      signKey: signKey,
      orderId: orderId,
      amount: amount,
      title: title,
      notifyUrl: notifyUrl,
      callbackInfo: callbackInfo,
      isProduction: isProduction,
    );

    final prepayId = prepayRes["prepay_id"];
    final nounceStr = _createRandomString();
    final timestamp = _createTimeStamp();

    final paymentReq = generatePaymentRequest(
      appId: appId,
      merchantCode: merchantCode,
      prepayId: prepayId,
      signKey: signKey,
      appScheme: appScheme,
      nounceString: nounceStr,
      timeStamp: timestamp,
    );

    await startPay(
      orderInfo: paymentReq.orderInfo,
      sign: paymentReq.sign,
      signType: paymentReq.signType,
      appScheme: paymentReq.appScheme,
    );
  }

  /// order info please create in server side. this function just a demo.
  PaymentRequestModel generatePaymentRequest({
    required String appId,
    required String merchantCode,
    required String prepayId,
    required String signKey,
    required String appScheme,
    required String nounceString,
    required String timeStamp,
  }) {
    const signType = "SHA256";
    final orderInfo = "appid=$appId&merch_code=$merchantCode&nonce_str="
        "$nounceString&prepay_id=$prepayId&timestamp=$timeStamp&key=$signKey";

    final sign = SHA.getSHA256Str(orderInfo);

    return PaymentRequestModel(
      orderInfo: orderInfo,
      sign: sign,
      signType: signType,
      appScheme: appScheme,
    );
  }

  static String _createRandomString() {
    final random = Random();
    final randomInt = random.nextInt(1 << 32); // 32-bit random integer
    return randomInt.toUnsigned(32).toString();
  }

  static String _createTimeStamp() {
    final int currentTimeInMillis = DateTime.now().millisecondsSinceEpoch;
    final double timeInSeconds = currentTimeInMillis / 1000;
    final int timeAsInt = timeInSeconds.toInt();
    return timeAsInt.toString();
  }

  String createOrderSign({
    required String appId,
    required String callbackInfo,
    required String merchantCode,
    required String orderId,
    required String method,
    required String nounceString,
    required String timeStamp,
    required String title,
    required double amount,
    required String signKey,
    String? notifyUrl,
  }) {
    return SHA
        .getSHA256Str(createQueryString(
          appId: appId,
          callbackInfo: callbackInfo,
          merchantCode: merchantCode,
          orderId: orderId,
          method: method,
          nounceString: nounceString,
          timeStamp: timeStamp,
          title: title,
          amount: amount,
          signKey: signKey,
          notifyUrl: notifyUrl,
        ))
        .toUpperCase();
  }

  String createQueryString({
    required String appId,
    required String callbackInfo,
    required String merchantCode,
    required String orderId,
    required String method,
    required String nounceString,
    required String timeStamp,
    required String title,
    required double amount,
    required String signKey,
    String? notifyUrl,
  }) {
    final queries = <String, String>{
      "appid": appId,
      "callback_info": callbackInfo,
      "merch_code": merchantCode,
      "merch_order_id": orderId,
      "method": method,
      "nonce_str": nounceString,
      "notify_url": notifyUrl.toString(),
      "timeout_express": "100m",
      "timestamp": timeStamp,
      "title": title,
      "total_amount": amount.toString(),
      "trade_type": "APP",
      "trans_currency": "MMK",
      "version": "1.0",
      "key": signKey,
    };
    return queries.keys.map((key) => "$key=${queries[key]}").join("&");
  }

  String generatePrecreateOrderRequsetBody({
    required String merchantCode,
    required String appId,
    required String signKey,
    required String orderId,
    required double amount,
    required String title,
    required String? notifyUrl,
    required String callbackInfo,
    required String nounceString,
    required String timeStamp,
    String method = "kbz.payment.precreate",
    String? urlScheme,
  }) {
    return jsonEncode({
      "Request": {
        "timestamp": timeStamp,
        "method": method,
        "notify_url": notifyUrl,
        "nonce_str": nounceString,
        "sign_type": "SHA256",
        "sign": createOrderSign(
          appId: appId,
          callbackInfo: callbackInfo,
          merchantCode: merchantCode,
          orderId: orderId,
          method: method,
          nounceString: nounceString,
          notifyUrl: notifyUrl,
          timeStamp: timeStamp,
          title: title,
          amount: amount,
          signKey: signKey,
        ).toUpperCase(),
        "version": "1.0",
        "biz_content": {
          "merch_order_id": orderId,
          "merch_code": merchantCode,
          "appid": appId,
          "trade_type": "APP",
          "title": title,
          "total_amount": amount.toString(),
          "trans_currency": "MMK",
          "timeout_express": "100m",
          "callback_info": callbackInfo,
        }
      }
    });
  }

  @override
  void addPaymentStatusListener() {
    _platform.addPaymentStatusListener();
  }
}
