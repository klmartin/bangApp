import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bangapp/services/token_storage_helper.dart';
import 'package:bangapp/constants/urls.dart';


 class  AuthService {

   Future<Map<String, dynamic>> addGoogleUser (userName,userEmail,userPic,userPhone,uid) async {
     try{
       print('nimeingia hapa');
       print("$baseUrl/v1/registerGoogleUser");
       final response = await http.post(
         Uri.parse('$baseUrl/v1/registerGoogleUser'),
         body: {
           'user_name': userName,
           'user_email': userEmail,
           'user_picture': userPic,
           'user_phone': userPhone ?? "",
           'uid' : uid,
         },
       );
       print(response.body);
       print('google user response');
       if (response.statusCode == 200) {
         return json.decode(response.body);
       }
       else {
        return {};
       }
     }
     catch(e){
       print(e);
       return {};
     }

   }

   bool validateEmail(String email) {
     // Regular expression for email validation
     // This regex checks for basic email pattern, but it may not cover all possible valid email formats
     final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

     // Check if the email matches the regex pattern
     return emailRegex.hasMatch(email);
   }

 }

