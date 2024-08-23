import 'package:ecommerce_app/provider/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({super.key, required this.username});
  final String username;
  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  @override
  void initState() {
    super.initState();
    // Load Cart products when the screen is initialized
    Future.microtask(() => Provider.of<CartProvider>(context, listen: false)
        .loadCartProducts(widget.username));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade900,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.grey.shade800,
          foregroundColor: Colors.white,
          title: Text('Shopping Bag',
              style: GoogleFonts.roboto(
                  textStyle: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold))),
        ),
        body: Consumer<CartProvider>(
          builder: (context, cartProvider, child) {
            if (cartProvider.cartProducts.isEmpty) {
              return const Expanded(
                child: Center(
                  child: Text(
                    'No Products found in Cart',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              );
            }
            return Column(
              children: [
                SizedBox(
                  height:
                      370.h, // Set the fixed height for the cart products area
                  child: ListView.builder(
                    itemCount: cartProvider.cartProducts.length,
                    itemBuilder: (context, index) {
                      final product = cartProvider.cartProducts[index];
                      return Dismissible(
                        key: Key(product['title']),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) async {
                          await cartProvider.removeFromCart(
                              widget.username, product['title']);
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          margin: const EdgeInsets.all(10),
                          child: Container(
                            alignment: Alignment.center,
                            height: 120.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey.shade800,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Image section
                                Container(
                                  width: 100.w,
                                  height: 130.h,
                                  margin: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.transparent,
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: product['image'],
                                    fit: BoxFit.fill,
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error,
                                            color: Colors.red),
                                  ),
                                ),
                                // Text and arrow section
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          product['title'],
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: GoogleFonts.lato(
                                            textStyle:  TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                         SizedBox(height: 5.h),
                                        Text(
                                          product['category'],
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                        ),
                                         SizedBox(height: 5.h),
                                        Text(
                                          '\$${product['price']}',
                                          style: GoogleFonts.lato(
                                            textStyle: TextStyle(
                                              color: Colors.white,
                                              fontSize: 12.sp,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        if (product['quantity'] > 1) {
                                          cartProvider
                                              .updateCartProductQuantity(
                                            widget.username,
                                            product['title'],
                                            -1,
                                          );
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.remove,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      '${product['quantity']}',
                                      style:  TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        cartProvider.updateCartProductQuantity(
                                          widget.username,
                                          product['title'],
                                          1,
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.add,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Spacer(),
                // Bag Total Row
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Bag Total',
                              style: GoogleFonts.roboto(
                                  textStyle:  TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize:24.sp))),
                          Consumer<CartProvider>(
                            builder: (context, value, child) => Text(
                                '\$${value.calculateTotalPrice().toStringAsFixed(2)}',
                                style: GoogleFonts.roboto(
                                    textStyle: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24.sp))),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 40,
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
                            onPressed: () {},
                            child:  Text(
                              'Proceed To Checkout',
                              style: TextStyle(
                                  fontSize: 18.sp, fontWeight: FontWeight.bold),
                            )),
                      ),
                    ],
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
