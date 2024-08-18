import 'dart:convert';

import 'package:http/http.dart' as http;
//this class used to sign up user

class UserService {
  static Future<Map<String, dynamic>> signUp(Map<String, dynamic> user) async {
    final response = await http.post(
      Uri.parse('https://fakestoreapi.com/users'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Faild to sign up');
    }
  }
}
