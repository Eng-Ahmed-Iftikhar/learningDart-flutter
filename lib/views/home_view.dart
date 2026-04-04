import 'package:flutter/material.dart';
import 'package:learningdart/services/auth/auth_service.dart';
import 'package:learningdart/views/email_verification_view.dart';
import 'package:learningdart/views/login_view.dart';
import 'package:learningdart/views/notes_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = AuthService.firebase();

    if (auth.currentUser == null) {
      return LoginView();
    }
    if (auth.currentUser?.isEmailVerified == false) {
      return EmailVerificationView();
    }
    return NotesView();
  }
}
