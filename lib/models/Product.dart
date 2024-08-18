import 'package:ecommerce_app/models/Rating.dart';

class Product {
  String title;
  double price;
  String description;
  String category;
  String image;
  Rating rating;

  Product(
      {required this.title,
      required this.price,
      required this.description,
      required this.category,
      required this.image,
      required this.rating});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        title: json['title'],
        price: json['price'].toDouble(),
        description: json['description'],
        category: json['category'],
        image: json['image'],
        rating: Rating.fromJson(json['rating']));
  }
}
