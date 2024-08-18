import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/Screens/Product_Details.dart';
import 'package:ecommerce_app/models/Product.dart';
import 'package:ecommerce_app/models/Rating.dart';
import 'package:ecommerce_app/provider/favorite_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rate/rate.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key, required this.username});
  final String username;
  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  void initState() {
    super.initState();
    // Load favorite products when the screen is initialized
    Future.microtask(() => Provider.of<FavoriteProvider>(context, listen: false)
        .loadFavoriteProducts(widget.username));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.grey.shade900,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.grey.shade800,
            title: Text('Favorite Products',
                style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold))),
          ),
          body: Consumer<FavoriteProvider>(
            builder: (context, favoriteProvider, child) {
              if (favoriteProvider.favoriteProducts.isEmpty) {
                return const Center(
                    child: Text(
                  'No favorite products found',
                  style: TextStyle(color: Colors.white),
                ));
              }
              return ListView.builder(
                itemCount: favoriteProvider.favoriteProducts.length,
                itemBuilder: (context, index) {
                  final product = favoriteProvider.favoriteProducts[index];
                  return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      margin: const EdgeInsets.all(10),
                      child: Container(
                        alignment: Alignment.center,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey.shade800,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Image section
                            Container(
                              width: 150,
                              height: 150,
                              margin: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.transparent,
                              ),
                              child: ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                child: CachedNetworkImage(
                                  imageUrl: product['image'],
                                  fit: BoxFit
                                      .cover, // Ensures image covers the container
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error, color: Colors.red),
                                ),
                              ),
                            ),
                            // Text and arrow section
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      product['title'],
                                      style: GoogleFonts.lato(
                                        textStyle: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      product['category'],
                                      style: GoogleFonts.lato(
                                        textStyle: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      '\$${product['price']}',
                                      style: GoogleFonts.lato(
                                        textStyle: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Rate(
                                      iconSize: 18,
                                      color: Colors.yellow.shade700,
                                      allowHalf: true,
                                      allowClear: true,
                                      initialValue: product['rating_rate'],
                                      readOnly: true,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Rating rating = Rating(
                                  rate: product['rating_rate'],
                                  count: product['rating_count'],
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetails(
                                      product: Product(
                                        title: product['title'],
                                        price: product['price'],
                                        description: product['description'],
                                        category: product['category'],
                                        image: product['image'],
                                        rating: rating,
                                      ),
                                      username: widget.username,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ));
                },
              );
            },
          )),
    );
  }
}
