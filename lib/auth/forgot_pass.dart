import 'package:flutter/material.dart';
import 'package:social/pages/home_page.dart';
import 'package:social/auth/sign_in.dart';
import 'package:social/auth/sign_up.dart';
import 'package:social/widgets/textfiled.dart'; // Ensure this path is correct
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPassPage extends StatefulWidget {
  const ForgotPassPage({super.key});

  @override
  State<ForgotPassPage> createState() => _ForgotPassPageState();
}

class _ForgotPassPageState extends State<ForgotPassPage> {
  final TextEditingController emailController = TextEditingController();

  Future<void> _signInWithEmailAndPassword() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please Write Your Email.'),
        ),
      );
    } else {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      _signIn();

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Check Your Inbox")));
    }
  }

  void _signUp() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignUpPage()),
    );
  }

  void _signIn() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignInPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.person,
                size: 155,
                color: Colors.deepPurple,
              ),
              const Text(
                "Recover Your Account",
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
              const SizedBox(height: 50.0),
              MyTextField(
                controller: emailController,
                label: 'Email',
                obscureText: false,
              ),
              const SizedBox(height: 20.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _signInWithEmailAndPassword,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.deepPurple, // Text color
                    textStyle: const TextStyle(fontSize: 18),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Reset Password"),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _signIn,
                    child: const Text(
                      "Sign In",
                      style: TextStyle(color: Colors.deepPurple, fontSize: 15),
                    ),
                  ),
                  TextButton(
                    onPressed: _signUp,
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.deepPurple, fontSize: 15),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
