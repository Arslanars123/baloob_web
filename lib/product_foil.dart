import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;

class ProductFoil extends StatefulWidget {
  @override
  _ProductFoilState createState() => _ProductFoilState();
}

class _ProductFoilState extends State<ProductFoil> {
  int _selectedIndex = 0;
  List<dynamic> products = [];
  bool isLoading = true;
  String? selectedColor;
  bool dropdownOpen = false;
  int _current = 0;
  int _selectedSize = 0;
  int _selectedColor = 0;
  int _counter = 1;
  Map<String, dynamic> selectedProduct = {};

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final response = await http.post(
        Uri.parse('http://92.112.194.129:3000/get-baloons'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'type': 'foil'}),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is List) {
          setState(() {
            products = data;
            isLoading = false;
            selectedProduct = products.isNotEmpty ? products[0] : {};
          });
        } else {
          throw FormatException('Expected a list, but got: ${data.runtimeType}');
        }
      } else {
        setState(() {
          isLoading = false;
        });
        print('Failed to load products. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  Color _getColorFromHex(String hexColor) {
    try {
      hexColor = hexColor.toUpperCase().replaceAll('#', '');
      if (hexColor.length == 6) {
        hexColor = 'FF' + hexColor;
      }
      return Color(int.parse(hexColor, radix: 16));
    } catch (e) {
      print('Error parsing color: $e');
      return Colors.grey; // Return a default color in case of error
    }
  }

  void _filterProducts(String color) {
    final filteredProduct = products.firstWhere((product) => product['color'] == color, orElse: () => {});
    setState(() {
      selectedProduct = filteredProduct;
    });
  }

  Future<void> _buyNow() async {
    // Create the cart item list
    final List<Map<dynamic, dynamic>> cartItems = [
      {
        'accessId': null,
        'baloonId': selectedProduct['_id'],
        'quantity': _counter.toString(),
        'image': selectedProduct['image'], // Include image URL
      },
    ];

    // Create the order data
    final Map<String, dynamic> orderData = {
      'userId': html.window.localStorage['userId'],
      'status': 'pending',
      'carts': cartItems,
    };

    try {
      final response = await http.post(
        Uri.parse('http://92.112.194.129:3000/store-order-mobile'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(orderData),
      );
      print(html.window.localStorage['userId'].toString());
      print(cartItems);
      if (response.statusCode == 200) {
        print("Order placed successfully");
        print(response.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order placed successfully!')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to place order.')));
        print('Order failed: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred')));
      print('Error: $e');
    }
  }

 void _addToCart() {
  final Map<String, dynamic> cartItem = {
    'accessId': null,
    'baloonId': selectedProduct['_id'],
    'quantity': _counter.toString(),
    'image': selectedProduct['image'], // Include image URL
    'description': selectedProduct['description'], // Include description
    'price': selectedProduct['price'].toString(), // Include price as a string
  };

  // Get existing cart from local storage
  String? existingCart = html.window.localStorage['userCart'];
  List<dynamic> userCart = existingCart != null ? jsonDecode(existingCart) : [];

  // Check if the user already has a cart
  int userIndex = userCart.indexWhere((cart) => cart['userId'] == html.window.localStorage['userId']);

  if (userIndex != -1) {
    // User already has a cart, update it
    userCart[userIndex]['carts'].add(cartItem);
  } else {
    // User doesn't have a cart, create a new one
    userCart.add({
      'userId': html.window.localStorage['userId'],
      'status': 'pending',
      'carts': [cartItem],
    });
  }
  print(userCart);
  // Save updated cart to local storage
  html.window.localStorage['userCart'] = jsonEncode(userCart);

  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Item added to cart!')));
}


  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Column(
                              children: [
                                Container(
                                  height: 200,
                                  width: 200,
                                  margin: EdgeInsets.all(10.0),
                                  child: Image.network(
                                    'http://92.112.194.129:3000/' + products[0]["image"],
                                    fit: BoxFit.contain,
                                    width: double.infinity,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(Icons.error);
                                    },
                                  ),
                                ),
                                SizedBox(height: 8),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Price',
                                    style: GoogleFonts.lato(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    '\$${selectedProduct['price'] ?? 'N/A'}',
                                    style: GoogleFonts.lato(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Text(
                                    'Choose Colors',
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 16),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            dropdownOpen = !dropdownOpen;
                                          });
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                selectedColor == null ? 'Select Color' : selectedColor!,
                                                style: GoogleFonts.lato(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Icon(Icons.arrow_drop_down)
                                            ],
                                          ),
                                        ),
                                      ),
                                      if (dropdownOpen)
                                        Container(
                                          height: MediaQuery.of(context).size.height / 5,
                                          margin: EdgeInsets.only(top: 8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(8),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 4.0,
                                                spreadRadius: 2.0,
                                              ),
                                            ],
                                          ),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: products.map((product) {
                                                String color = product['color'] ?? 'unknown';
                                                return InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      selectedColor = color;
                                                      dropdownOpen = false;
                                                      _filterProducts(color);
                                                    });
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          width: 24,
                                                          height: 24,
                                                          decoration: BoxDecoration(
                                                            color: _getColorFromHex(color),
                                                            shape: BoxShape.circle,
                                                          ),
                                                        ),
                                                        SizedBox(width: 8),
                                                        Text(
                                                          color,
                                                          style: GoogleFonts.lato(fontSize: 16),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  SizedBox(height: 16),
                                  _buildCounter(),
                                  SizedBox(height: 16),
                                  width > 659
                                      ? Row(
                                          children: [
                                            ElevatedButton(
                                              onPressed: _addToCart,
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Color(0xFF055C9D),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text('Add to Cart', style: GoogleFonts.lato(color: Colors.white, fontSize: 16)),
                                              ),
                                            ),
                                            SizedBox(width: 16),
                                            ElevatedButton(
                                              onPressed: _buyNow,
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Color(0xFF055C9D),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text('Buy Now', style: GoogleFonts.lato(color: Colors.white, fontSize: 16)),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Column(
                                          children: [
                                            ElevatedButton(
                                              onPressed: _addToCart,
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Color(0xFF055C9D),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text('Add to Cart', style: TextStyle(color: Colors.white)),
                                              ),
                                            ),
                                            SizedBox(height: 16),
                                            ElevatedButton(
                                              onPressed: _buyNow,
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Color(0xFF055C9D),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                                ),
                                              ),
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text('Buy Now', style: TextStyle(color: Colors.white)),
                                              ),
                                            ),
                                          ],
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildCounter() {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: () {
            if (_counter > 1) {
              setState(() {
                _counter--;
              });
            }
          },
        ),
        Text(
          '$_counter',
          style: TextStyle(fontSize: 16),
        ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            setState(() {
              _counter++;
            });
          },
        ),
      ],
    );
  }
}
