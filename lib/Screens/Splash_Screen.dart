import 'package:ecommerce_app/Screens/Login_Screen.dart';
import 'package:ecommerce_app/Screens/Sign_Up_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade900,
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  'assets/splash4.png',
                  width: 300,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Discover the best deals and latest trends!',
                style: GoogleFonts.roboto(
                  textStyle: TextStyle(color: Colors.white, fontSize: 25.sp),
                ),
              ),
              Text(
                'Everything you love, delivered to your door.\nFast and secure checkout process.\nQuality products, right at your doorstep.',
                style: GoogleFonts.roboto(
                  textStyle:  TextStyle(color: Colors.grey, fontSize: 15.sp),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                  decoration: const BoxDecoration(),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => LoginScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.all(10)),
                    child:  Text(
                      'GET STARTED',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
                    ),
                  )),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => SignScreen()));
                  },
                  child: const Text(
                    'Sign Up',
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
        ),
      ),
    );
  }
}
