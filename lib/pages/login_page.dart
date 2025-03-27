import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_provider/pages/home_page.dart';
import 'package:todo_list_provider/services/auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> signIn(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      await Auth().signInUserWithEmailPassword(
        email: email,
        password: password,
      );
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login Page"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: "Your email",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12.0),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Your password",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12.0),
              ElevatedButton(
                onPressed: () {
                  if (_emailController.text.isNotEmpty &&
                      _passwordController.text.isNotEmpty) {
                    signIn(
                      context,
                      _emailController.text,
                      _passwordController.text,
                    );
                    _emailController.clear();
                    _passwordController.clear();
                  }
                },
                child: Text("Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
