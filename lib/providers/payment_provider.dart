import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../services/azampay.dart';
import 'package:web_socket_channel/io.dart';
import '../services/token_storage_helper.dart';

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
    notifyListeners();
  }


  Future<bool> startPaying(phoneNumber, price, postId,type) async {
    _isPaying = true;
    _payedPost = postId;
    notifyListeners();
    Map<String, dynamic> pay = await AzamPay().checkoutData(phoneNumber, price, postId,type);
    var transactionId = pay['response']['transactionId'];
    // this line is to comment;
    //await AzamPay().saveDummyAzamPay(pay['response']['transactionId']);
     //if(transactionId){

      _processingStatusTimer = Timer.periodic(Duration(seconds: 2), (timer) {
        _fetchPaymentStatus(transactionId);
        notifyListeners();
      });
    //}

    return true;
  }

  Future<bool> _fetchPaymentStatus(transactionId) async {
    print("fetching");

    var status = await AzamPay().getPaymentStatus(transactionId);
    if(status == true ){
      _payed = true;
      notifyListeners();
    }
    if (status == true || _paymentCanceled== true) {
      _isFinishPaying = true;
      _isPaying = false;
      _processingStatusTimer?.cancel();
      notifyListeners();
    }
    return status;
  }
}
