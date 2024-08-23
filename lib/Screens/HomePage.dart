import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/Screens/Product_Details.dart';
import 'package:ecommerce_app/models/Product.dart';
import 'package:ecommerce_app/sevices/product_service.dart';
import 'package:ecommerce_app/widgets/category_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.username});
  final String username;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Product>> futureProducts;
  String selectedCategory = 'All';
  //Created to managed text input in search TextField
  TextEditingController searchController = TextEditingController();
  //List holds all products fetched from api
  List<Product> allProducts = [];
  //holds products currently displayed based on applied(category,search)
  List<Product> displayedProducts = [];

  void onCategorySelcted(String category) {
    setState(() {
      //Updates the selected category when the category is selected from CategoryNavBar Class
      selectedCategory = category;
      //filter products based on selected category
      filterProducts();
    });
  }

  //Method filter allProducts List on (selectedCategory,searchQuary)
  void filterProducts() {
    List<Product> filteredProducts = allProducts;
    //Filter based on selectedCategory
    if (selectedCategory != 'All') {
      filteredProducts = filteredProducts.where((product) {
        switch (selectedCategory) {
          case 'Men':
            return product.category == "men's clothing";
          case 'Women':
            return product.category == "women's clothing";
          case 'Electronics':
            return product.category == "electronics";
          case 'Jewelery':
            return product.category == "jewelery";
          default:
            return false;
        }
      }).toList();
    }
    //Filter based on search when any part on (product.title) typed on Search TextField
    //if any part of title found the product added to filteredProducts List
    String searchQuery = searchController.text.toLowerCase();
    if (searchQuery.isNotEmpty) {
      filteredProducts = filteredProducts.where((product) {
        return product.title.toLowerCase().contains(searchQuery);
      }).toList();
    }
    //Finally the displayedProducts updates with filteredProducts.
    setState(() {
      displayedProducts = filteredProducts;
    });
  }

  @override
  void initState() {
    super.initState();
    //Fetch all products from server by class ProductService
    futureProducts = ProductService.fetchProduct();
    //then after fetch put all products to allProducts List and displayedProducts List
    futureProducts.then((products) {
      setState(() {
        allProducts = products;
        displayedProducts = products;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade900,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 30,
                        )),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.notifications,
                          color: Colors.white,
                          size: 30,
                        )),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                'Discover the latest trends in fashion, cutting-edge electronics, and exquisite jewelry, all in one place!',
                style: GoogleFonts.roboto(
                    textStyle:
                         TextStyle(color: Colors.white, fontSize: 19.sp)),
              ),
              const SizedBox(
                height: 20,
              ),
              TextField(
                controller: searchController,
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  suffixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                  hintText: 'Search',
                  hintStyle: TextStyle(color: Colors.white),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                onChanged: (value) {
                  filterProducts();
                },
              ),
              const SizedBox(
                height: 20,
              ),
              CategoryNavBar(
                onCategorySelected: onCategorySelcted,
                categorySelected: selectedCategory,
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: FutureBuilder<List<Product>>(
                  future: futureProducts,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text('Falid to load products'),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('No products available'),
                      );
                    } else {
                      return GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ),
                        itemCount: displayedProducts.length,
                        itemBuilder: (context, index) {
                          Product product = displayedProducts[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ProductDetails(
                                        product: product,
                                        username: widget.username,
                                      )));
                            },
                            child: Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  //this to make a indecator loading while image load
                                  child: CachedNetworkImage(
                                    imageUrl: product.image,
                                    width: 200.w,
                                    height: 250.h,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  left: 0,
                                  child: Container(
                                    
                                    padding: const EdgeInsets.only(left: 5),
                                    width: double.infinity,
                                    height: 60.h,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.title,
                                          style: GoogleFonts.roboto(
                                              textStyle:  TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.bold)),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              '${product.rating.rate}',
                                              style: GoogleFonts.roboto(
                                                  textStyle:  TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10.sp)),
                                            ),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            const Icon(
                                              Icons.star,
                                              color: Colors.yellow,
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
