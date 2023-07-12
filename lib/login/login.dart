import 'package:fireship/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const FlutterLogo(
            size: 150,
          ),
          Flexible(
            child: LoginButton(
              text: 'Continue as Guest',
              color: Colors.deepPurple,
              icon: FontAwesomeIcons.userNinja,
              loginMethod: AuthService().anonLogin,
            ),
          ),
          LoginButton(
            text: 'Sign In With Google',
            color: Colors.blue,
            icon: FontAwesomeIcons.google,
            loginMethod: AuthService().googleLogin,
          ),
        ],
      ),
    ));
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    required this.color,
    required this.icon,
    required this.text,
    required this.loginMethod,
  });

  final Color color;
  final IconData icon;
  final String text;
  final Function loginMethod;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      child: ElevatedButton.icon(
        icon: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(24),
          backgroundColor: color,
        ),
        label: Text(text),
        onPressed: () => loginMethod(),
      ),
    );
  }
}
