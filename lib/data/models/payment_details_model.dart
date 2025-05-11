class PaymentDetails {
  final double netAmount;
  final double taxAmount;
  final double discount;
  final double invoiceTotal;
  final DateTime createdAt;

  PaymentDetails({
    required this.netAmount,
    required this.taxAmount,
    required this.discount,
    required this.invoiceTotal,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'netAmount': netAmount,
        'taxAmount': taxAmount,
        'invoiceTotal': invoiceTotal,
        'discount': discount,
        'createdAt': createdAt.toIso8601String(),
      };

  factory PaymentDetails.fromJson(Map<String, dynamic> json) => PaymentDetails(
        netAmount: json['netAmount'],
        taxAmount: json['taxAmount'],
        invoiceTotal: json['invoiceTotal'],
        discount: json['discount'],
        createdAt: DateTime.parse(json['createdAt']),
      );
}
