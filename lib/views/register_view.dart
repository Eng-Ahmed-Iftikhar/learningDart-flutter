import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:learningdart/services/auth/auth_exception.dart';
import 'package:learningdart/services/auth/auth_service.dart';
import 'package:learningdart/utilties/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
        backgroundColor: Colors.blue.shade500,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.black,
          statusBarBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
        ),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(hintText: "Enter your email here"),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: InputDecoration(hintText: "Enter your password here"),
          ),
          TextButton(
            onPressed: () async {
              try {
                final email = _email.text;
                final password = _password.text;

                if (email == "") {
                  return await showErrorDialog(context, "Email is required");
                } else if (password == "") {
                  return await showErrorDialog(context, "Email is required");
                }
                await AuthService.firebase().createUser(
                  email: email,
                  password: password,
                );

                await AuthService.firebase().sendEmailVerification();

                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil("/", (route) => false);
              } on WeakPasswordAuthException {
                showErrorDialog(context, "Weak password");
              } on EmailAlreadyInUseAuthException {
                showErrorDialog(context, "Email is already in use");
              } on InvalidEmailAuthException {
                showErrorDialog(context, "Invalid email address");
              } on GenericAuthException {
                showErrorDialog(context, "Authentication error");
              }
            },
            child: Text("Register"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil("/login", (route) => false);
            },
            child: Text("Already register? login here"),
          ),
        ],
      ),
    );
  }
}
