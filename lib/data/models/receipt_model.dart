import 'package:line_skip/data/models/item_model.dart';
import 'package:line_skip/data/models/store_model.dart';
import 'package:line_skip/data/models/transaction_model.dart';

import 'payment_details_model.dart';

class ReceiptModel {
  final String receiptId;
  final String user;
  final List<Item> items;
  final Store store;
  final String transactionId;
  final PaymentDetails paymentDetails;
  final TransactionModel transactionDetails;
  final DateTime createdAt;

  ReceiptModel({
    String? receiptId,
    required this.user,
    required this.items,
    required this.store,
    required this.transactionId,
    required this.paymentDetails,
    required this.transactionDetails,
    DateTime? createdAt,
  })  : receiptId = receiptId ?? _generateReceiptId(),
        createdAt = createdAt ?? DateTime.now();

  double get totalAmount => items.fold(0.0, (sum, item) => sum + item.price);

  String get formattedCreatedAt =>
      '${createdAt.day}/${createdAt.month}/${createdAt.year} ${createdAt.hour}:${createdAt.minute}';

  Map<String, dynamic> toJson() => {
        'receiptId': receiptId,
        'user': user,
        'items': items.map((i) => i.toJson()).toList(),
        'store': store.toJson(),
        'transactionId': transactionId,
        'paymentDetails': paymentDetails.toJson(),
        'transactionDetails': transactionDetails.toJson(),
        'createdAt': createdAt.toIso8601String(),
      };

  factory ReceiptModel.fromJson(Map<String, dynamic> json) => ReceiptModel(
        receiptId: json['receiptId'],
        user: json['user'],
        items: (json['items'] as List).map((e) => Item.fromJson(e)).toList(),
        store: Store.fromJson(json['store']),
        transactionId: json['transactionId'],
        paymentDetails: PaymentDetails.fromJson(json['paymentDetails']),
        transactionDetails:
            TransactionModel.fromJson(json['transactionDetails']),
        createdAt: DateTime.parse(json['createdAt']),
      );
}

String _generateReceiptId() {
  final now = DateTime.now();
  final timestamp = now.millisecondsSinceEpoch;
  final random = DateTime.now().microsecondsSinceEpoch % 100000;
  return 'LSRCPT-$timestamp-$random';
}
