import 'package:ecommerce_app/Screens/Login_Screen.dart';
import 'package:ecommerce_app/sevices/user_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignScreen extends StatefulWidget {
  const SignScreen({super.key});

  @override
  State<SignScreen> createState() => _SignScreenState();
}

class _SignScreenState extends State<SignScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _userNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  //Save user on api but (مجرد شكليات لأنه مبيخزنش مستخدمين)
  //Use Class UserService to signUp
  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      final user = {
        'email': _emailController.text,
        'username': _userNameController.text,
        'password': _passwordController.text,
        'name': {
          'firstname': _firstNameController.text,
          'lastname': _lastNameController.text,
        },
        'address': {
          'city': 'example city',
          'street': 'example street',
          'number': 123,
          'zipcode': '12345',
          'geolocation': {
            'lat': '0',
            'long': '0',
          },
        },
        'phone': '123-456-7890',
      };

      try {
        await UserService.signUp(user);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign up successful')),
        );

        // Navigate to the login screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to sign up')),
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
            padding: const EdgeInsets.only(top: 50, right: 20, left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    'assets/sign in.png',
                    width: 250,
                  ),
                ),
                Text(
                  'Sign up',
                  style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold)),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _firstNameController,
                              decoration: const InputDecoration(
                                  labelText: 'First Name',
                                  labelStyle: TextStyle(color: Colors.white)),
                              style: const TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your first name';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: TextFormField(
                              controller: _lastNameController,
                              decoration: const InputDecoration(
                                  labelText: 'Last Name',
                                  labelStyle: TextStyle(color: Colors.white)),
                              style: const TextStyle(color: Colors.white),
                              cursorColor: Colors.white,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your last name';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: _userNameController,
                        decoration: const InputDecoration(
                            labelText: 'Username',
                            labelStyle: TextStyle(color: Colors.white)),
                        style: const TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Username';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(color: Colors.white)),
                        style: const TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.white)),
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
                      TextFormField(
                        controller: _confirmPasswordController,
                        decoration: const InputDecoration(
                            labelText: 'Confirm Password',
                            labelStyle: TextStyle(color: Colors.white)),
                        obscureText: true,
                        style: const TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Password do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.all(10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: _signUp,
                          child: const Text(
                            'Sign up',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => const LoginScreen()));
                          },
                          child: const Text(
                            'Login',
                            style: TextStyle(
                                decorationColor: Colors.white,
                                decoration: TextDecoration.underline,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
