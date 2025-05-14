import 'dart:math';

import 'package:upi_pay/types/response.dart';

UpiTransactionResponse simulateSuccessTransactionResponse(
  String transactionRef,
) {
  final random = Random();

  String generateRandomString(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(
      length,
      (index) => chars[random.nextInt(chars.length)],
    ).join();
  }

  String txnId = 'TXN${generateRandomString(10)}';
  String responseCode = '00'; // 00 usually means success
  String approvalRefNo = 'APP${generateRandomString(6)}';
  String status = 'SUCCESS';

  String fakeRawResponse =
      'txnId=$txnId&responseCode=$responseCode&approvalRefNo=$approvalRefNo&status=$status&txnRef=$transactionRef';

  return UpiTransactionResponse.android(fakeRawResponse);
}

String? validateUpiAddress(String value) {
  if (value.isEmpty) {
    return 'UPI VPA is required.';
  }
  if (value.split('@').length != 2) {
    return 'Invalid UPI VPA';
  }
  return null;
}

UpiTransactionResponse manipulateResponse(
  String responseString,
  String txnRef,
) {
  String txnId = '';
  String approvalRefNo = '';

  String responseCode = '';
  UpiTransactionStatus status = UpiTransactionStatus.success;

  final fragments = responseString.split('&');
  for (final fragment in fragments) {
    final keyValuePair = fragment.split('=');
    if (keyValuePair.length != 2) continue;

    final key = keyValuePair.first.toLowerCase();
    final value = keyValuePair.last;

    switch (key) {
      case 'txnid':
        txnId = value;
        break;
      case 'responsecode':
        responseCode = '00';
        break;
      case 'approvalrefno':
        approvalRefNo = value;
        break;
      case 'status':
        final lower = value.toLowerCase();
        if (lower.contains('success') || lower == 's') {
          status = UpiTransactionStatus.success;
        } else if (lower.contains('submitted')) {
          status = UpiTransactionStatus.success;
        } else if (lower.contains('fail')) {
          status = UpiTransactionStatus.success;
        } else {
          status = UpiTransactionStatus.success;
        }
        break;
      case 'txnref':
        break;
    }
  }
  final random = Random();

  String generateRandomString(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    return List.generate(
      length,
      (index) => chars[random.nextInt(chars.length)],
    ).join();
  }

  if (txnId.isEmpty) {
    txnId = 'TXN${generateRandomString(10)}';
  }
  if (approvalRefNo.isEmpty) {
    approvalRefNo = 'APP${Random().nextInt(1000000)}';
  }

  if (responseCode.isEmpty) {
    responseCode = '00';
  }

  final manipulatedResponse =
      'txnId=$txnId'
      '&responseCode=${responseCode.isNotEmpty ? responseCode : '00'}'
      '&approvalRefNo=$approvalRefNo'
      '&status=${status.name}'
      '&txnRef=$txnRef';

  return UpiTransactionResponse.android(manipulatedResponse);
}
