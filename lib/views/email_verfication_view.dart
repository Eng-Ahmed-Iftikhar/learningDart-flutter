import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailVerficationView extends StatefulWidget {
  const EmailVerficationView({super.key});

  @override
  State<EmailVerficationView> createState() => _EmailVerficationViewState();
}

class _EmailVerficationViewState extends State<EmailVerficationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify email")),
      body: Column(
        children: [
          Text("Please verify your email"),
          TextButton(
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              await user?.sendEmailVerification();
            },
            child: Text("Send email verification"),
          ),
        ],
      ),
    );
  }
}
