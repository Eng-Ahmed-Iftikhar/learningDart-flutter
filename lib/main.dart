import 'package:flutter/material.dart';
import 'package:learningdart/services/auth/auth_service.dart';
import 'package:learningdart/views/email_verification_view.dart';
import 'package:learningdart/views/home_view.dart';
import 'package:learningdart/views/login_view.dart';
import 'package:learningdart/views/register_view.dart';

import 'constants/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return MaterialApp(
              title: 'Flutter Demo',
              theme: ThemeData(primarySwatch: Colors.blue),
              initialRoute: "/",
              routes: {
                homeRoute: (context) => HomeView(),
                loginRoute: (context) => LoginView(),
                registerRoute: (context) => RegisterView(),
                emailVerificationRoute: (context) => EmailVerificationView(),
              },
            );
          default:
            return CircularProgressIndicator();
        }
      },
    );
  }
}
