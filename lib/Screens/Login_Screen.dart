import 'package:ecommerce_app/Screens/Sign_Up_Screen.dart';
import 'package:ecommerce_app/database/db_helper.dart';
import 'package:ecommerce_app/sevices/auth_service.dart';
import 'package:ecommerce_app/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  //this function used to check if the user login in this device or not
  //if yes we will enter direct to home page
  Future<void> _checkLoginStatus() async {
    final dbHelper = DatabaseHelper();

    final user = await dbHelper.getUser();
    if (user != null) {
      _userNameController.text = user['username']!;
      _passwordController.text = user['password']!;
    }
  }

  //this function user class AuthService to login user
  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        await AuthService.login(
          _userNameController.text,
          _passwordController.text,
        );

        // Save login information
        final dbHelper = DatabaseHelper();
        await dbHelper.insertUser(
          _userNameController.text,
          _passwordController.text,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful')),
        );

        // Navigate to the main screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => ButtomNavScreen(
                    username: _userNameController.text,
                  )),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid email or password')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 30, right: 20, left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Image.asset(
                  'assets/login.png',
                  width: 400,
                )),
                Text(
                  'Login',
                  style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold)),
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _userNameController,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            labelStyle: TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          style: const TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username';
                            }

                            return null;
                          },
                        ),
                        const SizedBox(height: 20), // Added spacing
                        TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          obscureText: true,
                          style: const TextStyle(color: Colors.white),
                          cursorColor: Colors.white,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters long';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.all(10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )),
                              onPressed: _login,
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold),
                              )),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Do not have an account?',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SignScreen()));
                              },
                              child: const Text(
                                'Sign up',
                                style: TextStyle(
                                    decorationColor: Colors.white,
                                    decoration: TextDecoration.underline,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                          ],
                        )
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
