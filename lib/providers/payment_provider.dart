import 'dart:async';
import 'package:flutter/material.dart';
import '../services/azampay.dart';

class PaymentProvider extends ChangeNotifier {
  bool _isPaying = false;
  bool _payed = false;
  bool _isFinishPaying = false;
  bool _paymentCanceled = false;
  int _payedPost = 0;
  String _payingText = 'Processing Payment...';
  bool get isPaying => _isPaying;
  bool get isFinishPaying => _isFinishPaying;
  bool get payed => _payed;
  String get payingText => _payingText;
  int get payedPost => _payedPost;
  bool get paymentCanceled => _paymentCanceled;
  Timer? _processingStatusTimer;

  set paymentCanceled(bool value) {
    _paymentCanceled = value;
    _isPaying = false;
    notifyListeners();
  }

  Future<void> startPaying(phoneNumber, price, postId, type) async {
    _isPaying = true;
    _payedPost = postId;
    notifyListeners();

    Map<String, dynamic> pay = await AzamPay().checkoutData(phoneNumber, price, postId, type);

    if(pay.isNotEmpty)
      {
        var transactionId = pay['response']['transactionId'];
        _isPaying = false;
        notifyListeners();
        _processingStatusTimer = Timer.periodic(Duration(seconds: 2), (timer) {
          _fetchPaymentStatus(transactionId);
          notifyListeners();
        });
      }
    else{
      _isPaying = false;
      notifyListeners();
    }

  }


  Future<bool> _fetchPaymentStatus(transactionId) async {
    var status = await AzamPay().getPaymentStatus(transactionId);
    if(status == true ){
      _payed = true;
      _processingStatusTimer?.cancel();
      notifyListeners();
    }
    if ( _paymentCanceled== true) {
      _isFinishPaying = true;
      _isPaying = false;
      _processingStatusTimer?.cancel();
      notifyListeners();
    }
    return status;
  }
}
