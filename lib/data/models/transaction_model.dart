enum UpiTransactionStatus {
  success,
  failure,
  submitted,
  unknown,
}

class TransactionModel {
  final String userid;
  final String transactionId;
  final double amount;
  final String status;
  final String transactionRef;
  final String approvalRefNo;
  final String responseCode;
  final String receiverName;
  final String receiverUpiAddress;
  final String upiApplication;
  final String transactionNote;
  final UpiTransactionStatus statusEnum;
  final DateTime createdAt;

  TransactionModel({
    required this.userid,
    required this.transactionId,
    required this.amount,
    required this.status,
    required this.transactionRef,
    required this.approvalRefNo,
    required this.responseCode,
    required this.receiverName,
    required this.receiverUpiAddress,
    required this.upiApplication,
    required this.transactionNote,
    this.statusEnum = UpiTransactionStatus.success,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'userid': userid,
        'transactionId': transactionId,
        'amount': amount,
        'status': status,
        'transactionRef': transactionRef,
        'approvalRefNo': approvalRefNo,
        'responseCode': responseCode,
        'receiverName': receiverName,
        'receiverUpiAddress': receiverUpiAddress,
        'upiApplication': upiApplication,
        'transactionNote': transactionNote,
        'statusEnum': statusEnum.toString(),
        'createdAt': createdAt.toIso8601String(),
      };

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        userid: json['userid'],
        transactionId: json['transactionId'],
        amount: json['amount'],
        status: json['status'],
        transactionRef: json['transactionRef'],
        approvalRefNo: json['approvalRefNo'],
        responseCode: json['responseCode'],
        receiverName: json['receiverName'],
        receiverUpiAddress: json['receiverUpiAddress'],
        upiApplication: json['upiApplication'],
        transactionNote: json['transactionNote'],
        statusEnum: UpiTransactionStatus.values
            .firstWhere((e) => e.toString() == json['statusEnum']),
        createdAt: DateTime.parse(json['createdAt']),
      );
}
