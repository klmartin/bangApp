import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentService {
  static const String baseUrl = 'https://openapiuat.airtel.africa/merchant/v2/payments/';

  static Future<void> airtelMoney(int amount) async {
    final url = Uri.parse(baseUrl);
    final headers = {
      'Accept': '*/*',
      'Content-Type': 'application/json',
      'X-Country': 'TZ',
      'X-Currency': 'TSH',
      'Authorization': 'Bearer gGfp3gNnh1skKZKP6wknvMSlSH8DJUA4',
      'x-signature': 'MGsp*****************Ag==',
      'x-key': 'DVZC*******************NM=',
    };

    final body = {
      "reference": "Testing transaction",
      "subscriber": {
        "country": "TZ",
        "currency": "TSH",
        "msisdn": "12****89",
      },
      "transaction": {
        "amount": amount,
        "country": "TZ",
        "currency": "TSH",
        "id": "random-unique-id",
      },
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print(responseData);
        // Handle the response data as needed
      } else {
        print('Request failed with status: ${response.statusCode}');
        // Handle the error
      }
    } catch (e) {
      print('Error: $e');
      // Handle the error
    }
  }
}
