import 'dart:convert';

import 'package:ecommerce_app/models/Product.dart';
import 'package:http/http.dart' as http;

class ProductService {
  static const String apiUrl = 'https://fakestoreapi.com/products';
  static Future<List<Product>> fetchProduct() async {
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Faild to load products');
    }
  }
}
