class PaymentStatus {
  final String status;
  final String message;

  const PaymentStatus({
    required this.status,
    required this.message,
  });

  factory PaymentStatus.fromJson(Map<String, dynamic> json) {
    return PaymentStatus(
      status: json["status"],
      message: json["message"],
    );
  }
}
