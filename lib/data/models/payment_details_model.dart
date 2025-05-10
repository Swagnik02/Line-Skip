class PaymentDetails {
  final double totalAmount;
  final double tax;
  final double discount;
  final DateTime createdAt;

  PaymentDetails({
    required this.totalAmount,
    required this.tax,
    required this.discount,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  double get totalPayable => totalAmount + tax;

  Map<String, dynamic> toJson() => {
        'totalAmount': totalAmount,
        'tax': tax,
        'discount': discount,
        'createdAt':
            createdAt.toIso8601String(), // This is for JSON serialization
      };

  factory PaymentDetails.fromJson(Map<String, dynamic> json) => PaymentDetails(
        totalAmount: json['totalAmount'],
        tax: json['tax'],
        discount: json['discount'],
        createdAt: DateTime.parse(json['createdAt']),
      );
}
