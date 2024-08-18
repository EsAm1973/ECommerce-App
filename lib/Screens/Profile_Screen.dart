import 'package:ecommerce_app/Screens/Login_Screen.dart';
import 'package:ecommerce_app/widgets/profile_details.dart';
import 'package:flutter/material.dart';

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
                  const CircleAvatar(
                    radius: 50,
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
            const SizedBox(height: 10),
            Text(
              widget.username,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
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
                  const SizedBox(height: 20),
                  ListTile(
                    leading: const Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    title: const Text(
                      'Log Out',
                      style: TextStyle(color: Colors.white),
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
