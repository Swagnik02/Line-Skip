class PaymentDetails {
  final double totalAmount;
  final double tax;
  final double discount;
  final DateTime createdAt = DateTime.now();

  PaymentDetails({
    required this.totalAmount,
    required this.tax,
    required this.discount,
  });

  /// Computed property
  double get totalPayable => totalAmount + tax;

  Map<String, dynamic> toJson() => {
        'totalAmount': totalAmount,
        'tax': tax,
        'discount': discount,
        'createdAt': createdAt.toIso8601String(),
      };

  factory PaymentDetails.fromJson(Map<String, dynamic> json) => PaymentDetails(
        totalAmount: json['totalAmount'],
        tax: json['tax'],
        discount: json['discount'],
      );
}
