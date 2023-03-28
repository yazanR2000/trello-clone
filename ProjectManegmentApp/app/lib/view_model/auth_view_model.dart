import 'dart:convert';
import 'dart:io';

import 'package:app/models/auth_model.dart';
import 'package:app/res/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../views/home_view.dart';

class AuthViewModel with ChangeNotifier {
  AuthType authType = AuthType.login;

  Map<String, dynamic>? user;

  List<dynamic> myCards = [];

  void changeAuthType() {
    authType = authType == AuthType.login ? AuthType.signUp : AuthType.login;
    notifyListeners();
  }

  Future authenticate(
      Map<String, dynamic> userData, BuildContext context) async {
    NavigatorState navigator = Navigator.of(context);
    try {
      print(authType);
      var response;
      if (authType == AuthType.login) {
        response =
            await AuthModel.login(userData['email'], userData['password']);
      } else {
        response = await AuthModel.signup(
          userData['email'],
          userData['password'],
          userData['username'],
          userData['role'],
        );
      }
      // print(response.body);
      final data = json.decode(response.body);
      // print(data);
      final SharedPreferences pref = await SharedPreferences.getInstance();
      await pref.setString('user', json.encode(data['data']));
      // print(pref.getString('user'));
      navigator.pop();
      notifyListeners();
      navigator.pushNamed(HomeView.routeName);
    } catch (err) {
      print(err);
    }
  }

  Future logout() async {
    print("yazan1");
    await _removeAuthData();
  }

  Future<void> _removeAuthData() async {
    print("yazan2");
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('user')) {
      print("yes");
      await prefs.remove('user');
    }
  }

  Future getMyCards() async {
    try{
      final response = await AuthModel.getMyCards(user!['id']);
      myCards = json.decode(response.body);
      print(myCards);
    }catch(err){
      print(err);
    }
  }
}

enum AuthType { login, signUp }
