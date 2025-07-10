import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/auth_provider.dart';
import '../navigation/main_navigation.dart';   
import '../views/login/login_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    // 1) Splash / Busy
    if (auth.isBusy) {
      return const Scaffold(
        backgroundColor: Color(0xFF121212),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // 2) Login successful or guest
    if (auth.isLoggedIn || auth.isGuest) {
      return MainNavigation();
    }

    // 3) Otherwise show login page
    return const LoginPage();
  }
}