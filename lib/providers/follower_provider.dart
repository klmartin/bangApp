import 'dart:async';
import 'package:bangapp/providers/post_likes.dart';
import 'package:flutter/material.dart';
import '../services/azampay.dart';
import '../services/service.dart';


class FollowerProvider extends ChangeNotifier {
  bool _isPaying = false;
  bool _payed = false;
  bool _isFinishPaying = false;
  bool _paymentCanceled = false;
  int _payedPost = 0;
  final List<User> _allFollowers = [];
  List<User> get allFollowers => _allFollowers;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _payingText = 'Processing Payment...';
  int _followersCount = 0;
  bool get isPaying => _isPaying;
  bool get isFinishPaying => _isFinishPaying;
  bool get payed => _payed;
  String get payingText => _payingText;
  int get followersCount => _followersCount;
  int get payedPost => _payedPost;
  bool get paymentCanceled => _paymentCanceled;
  Timer? _processingStatusTimer;
  set paymentCanceled(bool value) {
    _paymentCanceled = value;
    _isPaying = false;
    notifyListeners();
  }

  set resetFollowerCount(int value) {
    _followersCount = value;
    notifyListeners();
  }
  Future<bool> startPaying(phoneNumber, price, postId,type,hobbies) async {
    _isPaying = true;
    _payedPost = postId;
    notifyListeners();
    Map<String, dynamic> pay = await AzamPay().checkoutData(phoneNumber, price, postId,type);
    if(pay.isNotEmpty ){
      var transactionId = pay['response']['transactionId'];
      //await AzamPay().saveDummyAzamPay(transactionId,type);
      _processingStatusTimer = Timer.periodic(Duration(seconds: 2), (timer) {
        _fetchPaymentStatus(transactionId,hobbies);
        notifyListeners();
      });
    }
    else{
      _isPaying = false;
      notifyListeners();
    }
    return true;
  }

  Future<bool> _fetchPaymentStatus(transactionId,hobbies) async {
    var status = await AzamPay().getPaymentStatus(transactionId);
    if(status == true ){
      _isPaying = false;
      _processingStatusTimer?.cancel();
      _followersCount = await Service().buyFollowers(payedPost,hobbies);
      _payed = true;
      notifyListeners();
    }
    if (_paymentCanceled== true) {
      _isFinishPaying = true;
      _isPaying = false;
      _processingStatusTimer?.cancel();
      notifyListeners();
    }
    return status;
  }

  Future<void> getAllFollowers({userId}) async {
    _isLoading = true;
    _allFollowers.clear();
    notifyListeners();
    var allFollowers;
    if (userId != null) {
      allFollowers = await Service().getFollowers(userId: userId);
    } else {
      allFollowers = await Service().getFollowers();
    }
    _allFollowers.addAll(
      (allFollowers as List)
          .map((user) => User.fromJson(user))
          .toList(),
    );
    _isLoading = false;
    notifyListeners();
  }

}
