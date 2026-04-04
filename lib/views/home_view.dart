import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learningdart/views/email_verification_view.dart';
import 'package:learningdart/views/login_view.dart';
import 'package:learningdart/views/notes_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;

    if (auth.currentUser == null) {
      return LoginView();
    }
    if (auth.currentUser?.emailVerified == false) {
      return EmailVerificationView();
    }
    return NotesView();
  }
}
