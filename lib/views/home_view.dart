import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learningdart/firebase_options.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        elevation: 3,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight(600),
        ),
        backgroundColor: Colors.blue.shade500,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.black,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      body: FutureBuilder(
        builder: (context, snapshot) {
          final auth = FirebaseAuth.instance;
          final user = auth.currentUser;

          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Text("home");
            default:
              return const Text("Loading...");
          }
        },
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
      ),
    );
  }
}
