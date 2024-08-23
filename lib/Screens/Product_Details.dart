import 'package:ecommerce_app/Screens/Cart_Screen.dart';
import 'package:ecommerce_app/models/Product.dart';
import 'package:ecommerce_app/provider/cart_provider.dart';
import 'package:ecommerce_app/provider/favorite_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rate/rate.dart';

class ProductDetails extends StatefulWidget {
  const ProductDetails(
      {super.key, required this.product, required this.username});
  final Product product;
  final String username;
  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  bool isFavorite = false;
  late FavoriteProvider _favoriteProvider;
  late CartProvider _cartProvider;

  @override
  void initState() {
    super.initState();
    _cartProvider = Provider.of<CartProvider>(context, listen: false);
    _favoriteProvider = Provider.of<FavoriteProvider>(context, listen: false);
    _favoriteProvider.checkIfFavorite(widget.username, widget.product.title);
  }

  void _addToCart() async {
    bool isInCart = await _cartProvider.isProductInCart(
        widget.username, widget.product.title);
    if (isInCart) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product is already in the cart!')),
      );
    } else {
      await _cartProvider.addToCart(widget.username, {
        'title': widget.product.title,
        'price': widget.product.price,
        'description': widget.product.description,
        'category': widget.product.category,
        'image': widget.product.image,
        'rating_rate': widget.product.rating.rate,
        'rating_count': widget.product.rating.count,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product added to the cart!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding:
                const EdgeInsets.only(top: 20, right: 20, left: 20, bottom: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Stack(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      ShoppingCart(username: widget.username)));
                            },
                            icon: const Icon(
                              Icons.shopping_bag_outlined,
                              color: Colors.white,
                            ),
                          ),
                          Consumer<CartProvider>(
                            builder: (context, cartProvider, child) {
                              return Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors
                                        .red, // Background color of the notification badge
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  constraints: BoxConstraints(
                                    minWidth: 10.w,
                                    minHeight: 20.h,
                                  ),
                                  child: Text(
                                    '${cartProvider.cartProducts.length}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Consumer<FavoriteProvider>(
                      builder: (context, favoriteProvider, child) => Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: IconButton(
                          onPressed: () {
                            _favoriteProvider.toggleFavorite(widget.username, {
                              'title': widget.product.title,
                              'price': widget.product.price,
                              'description': widget.product.description,
                              'category': widget.product.category,
                              'image': widget.product.image,
                              'rating_rate': widget.product.rating.rate,
                              'rating_count': widget.product.rating.count,
                            });
                          },
                          icon: Icon(
                            favoriteProvider.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: favoriteProvider.isFavorite
                                ? Colors.red
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height / 40,
                ),
                Container(
                  width: 300.w,
                  height: 250.h,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(widget.product.image))),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
                  width: double.infinity,
                  height: 300.r,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    children: [
                      Text(
                        textAlign: TextAlign.center,
                        widget.product.title,
                        style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                        )),
                        maxLines: 1,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height / 50,
                      ),
                      SizedBox(
                        height: 100.h,
                        child: SingleChildScrollView(
                          child: Text(
                            textAlign: TextAlign.start,
                            widget.product.description,
                            style: GoogleFonts.roboto(
                              textStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '\$${widget.product.price}',
                                style: GoogleFonts.roboto(
                                    textStyle: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                )),
                              ),
                              Rate(
                                iconSize: 25,
                                color: Colors.yellow.shade700,
                                allowHalf: true,
                                allowClear: true,
                                initialValue: widget.product.rating.rate,
                                readOnly: true,
                              ),
                            ],
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 30)),
                            onPressed: _addToCart,
                            child: Text(
                              'Add to cart',
                              style: GoogleFonts.roboto(
                                  textStyle: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}
