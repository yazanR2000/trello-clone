import 'dart:convert';

import '../res/constants.dart';
import 'package:http/http.dart' as http;

class AuthModel {
  static Future login(String email, String password) async {
    final url = Uri.http(Constants.baseUrl, '/user/login');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(
        {
          "email": email,
          "password": password,
        },
      ),
    );
  }
  static Future signup(String email,String password,String username,String role) async {
    final url = Uri.http(Constants.baseUrl, '/user/signup');
    return await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(
        {
          "email": email,
          "password": password,
          "name": username,
          "role": role
        },
      ),
    );
  }
  static Future getMyCards(int userId) async{
    final url = Uri.http(Constants.baseUrl, '/user/my-cards/$userId');
    return await http.get(url);
  }
}
