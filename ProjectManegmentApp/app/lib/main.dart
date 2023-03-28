
import 'package:app/view_model/project_view_model.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:provider/provider.dart';

import 'view_model/home_view_model.dart';
import 'view_model/auth_view_model.dart';
// import 'package:flutter/services.dart';

import 'views/auth_view.dart';
import 'views/home_view.dart';
import 'views/splash_view.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => HomeViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProjectViewModel(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      debugShowCheckedModeBanner: false,
      title: 'OPRUP Manegment',
      themeMode: ThemeMode.system,
      theme: ThemeData(
        brightness: Brightness.light,
        fontFamily: 'Ubuntu-Regular',
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Ubuntu-Regular',
      ),
      initialRoute: SplashView.routeName,
      routes: {
        AuthView.routeName: (_) => AuthView(),
        HomeView.routeName: (_) => const HomeView(),
        // LecturesView.routeName: (_) => const LecturesView(),
        // LectureAttendanceView.routeName : (_) => const LectureAttendanceView(),
        SplashView.routeName :(_) => const SplashView(),
      },
    );
  }
}