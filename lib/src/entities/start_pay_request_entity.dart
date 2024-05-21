class PaymentRequestModel {
  final String orderInfo;
  final String sign;
  final String signType;
  final String appScheme;

  const PaymentRequestModel({
    required this.orderInfo,
    required this.sign,
    required this.signType,
    required this.appScheme,
  });

  Map<String, dynamic> toJson() {
    return {
      "orderInfo": orderInfo,
      "sign": sign,
      "signType": signType,
      "appScheme": appScheme,
    };
  }

  @override
  String toString() {
    return 'PaymentRequestModel(orderInfo: $orderInfo, sign: $sign, signType: $signType, appScheme: $appScheme)';
  }

  @override
  bool operator ==(covariant PaymentRequestModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.orderInfo == orderInfo &&
      other.sign == sign &&
      other.signType == signType &&
      other.appScheme == appScheme;
  }

  @override
  int get hashCode {
    return orderInfo.hashCode ^
      sign.hashCode ^
      signType.hashCode ^
      appScheme.hashCode;
  }
}
