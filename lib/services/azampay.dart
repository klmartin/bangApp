
import 'package:bangapp/constants/urls.dart';
import 'package:date_format/date_format.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';


class AzamPay {

  Future<Map<String, dynamic>> checkoutData(phoneNumber,amount,postId,type) async {
    print([postId,amount, phoneNumber]);
    print('this is checkout data');
    final String apiUrl = 'http://bangapp.pro:3001/azampay/checkout';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> data = {
      'phone_number': phoneNumber,
      'amount': amount.toString(),
      'post_id': postId.toString(), // Replace with your actual values
      'user_id': prefs.getInt('user_id').toString(), // Replace with your actual values
      'type': type,
    };

    final http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      print(response.body);
      print('response azampay body');
      return jsonDecode(response.body);
    } else {
      return {};
    }
  }

  Future<bool>getPaymentStatus(transactionId) async {
    final http.Response response = await http.get(
      Uri.parse('$baseUrl/getPaymentStatus/$transactionId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    if(response.statusCode == 200){
      final status = jsonDecode(response.body);

      return status['status'];
    }
    else{
      return false;
    }
  }

}
