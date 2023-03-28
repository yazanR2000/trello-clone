import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';
import '../views/auth_view.dart';
import '../views/home_view.dart';
import 'auth_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashViewModel {
  Future<void> getInitData(BuildContext context) async {
    final AuthViewModel authProvider =
        Provider.of<AuthViewModel>(context, listen: false);
    final NavigatorState navigator = Navigator.of(context);
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.containsKey('user')) {
      authProvider.user = json.decode(preferences.getString('user')!);
      // print(authProvider.user);
    }
    // InstructorModel? instructorModel = await InstructorModel.instance.getAuthData();
    // if (instructorModel != null) {
    if (authProvider.user != null) {
      // authProvider.setUser = instructorModel;
      navigator.pushReplacementNamed(HomeView.routeName);
      return;
    }
    navigator.pushReplacementNamed(AuthView.routeName);
  }
}
