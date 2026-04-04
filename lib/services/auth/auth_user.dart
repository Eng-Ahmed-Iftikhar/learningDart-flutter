import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

@immutable
class AuthUser {
  final bool isEmailVerified;
  final String? email;
  const AuthUser._(this.isEmailVerified, this.email);

  factory AuthUser.fromFirebase(User user) =>
      AuthUser._(user.emailVerified, user.email);
}
