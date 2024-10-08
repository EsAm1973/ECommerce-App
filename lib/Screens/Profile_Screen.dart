import 'package:ecommerce_app/Screens/Login_Screen.dart';
import 'package:ecommerce_app/widgets/profile_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.username});
  final String username;
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.grey.shade800,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50.r,
                    backgroundImage: NetworkImage(
                        'https://uxwing.com/wp-content/themes/uxwing/download/peoples-avatars/user-profile-icon.png'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade700,
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(
                        Icons.edit,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            Text(
              widget.username,
              style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: ListView(
                children: [
                  ProfileItem(
                    icon: Icons.person,
                    title: widget.username,
                    onTap: () {},
                  ),
                  ProfileItem(
                    icon: Icons.email,
                    title: 'example@gmail.com',
                    onTap: () {},
                  ),
                  ProfileItem(
                    icon: Icons.lock,
                    title: '********',
                    onTap: () {},
                  ),
                  ProfileItem(
                    icon: Icons.location_on,
                    title: 'Egypt, Cairo',
                    onTap: () {},
                  ),
                  ProfileItem(
                    icon: Icons.support,
                    title: 'Support',
                    onTap: () {},
                  ),
                  SizedBox(height: 10.h),
                  ListTile(
                    leading: const Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    title:  Text(
                      'Log Out',
                      style: TextStyle(fontSize: 15.sp,color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                          (route) => false);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
