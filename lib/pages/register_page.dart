import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_provider/pages/home_page.dart';
import 'package:todo_list_provider/pages/login_page.dart';
import 'package:todo_list_provider/services/auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  Future<void> register(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      await Auth().registerUserWithEmailPassword(
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
      appBar: AppBar(title: Text("Register Page"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: "Your email",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12.0),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Your password",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12.0),
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: "Confirm password",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 12.0),
              ElevatedButton(
                onPressed: () {
                  if (_emailController.text.isNotEmpty &&
                      _passwordController.text.isNotEmpty &&
                      _passwordController.text == _emailController.text) {
                    register(
                      context,
                      _emailController.text,
                      _passwordController.text,
                    );
                    _emailController.clear();
                    _passwordController.clear();
                  }
                },
                child: Text("Register"),
              ),
              SizedBox(height: 12.0),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
                child: Text("Already have an account? Login!"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
