import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;

class Balloon {
  final String id;
  final String name;
  final String imageUrl;
  final String color;
  final String size;
  final String sizeId; // Added sizeId field
  final int quantity;
  final String price;

  Balloon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.color,
    required this.size,
    required this.sizeId, // Add sizeId to constructor
    required this.quantity,
    required this.price,
  });

  factory Balloon.fromJson(Map<String, dynamic> json) {
    return Balloon(
      id: json['_id'] ?? '',
      name: json['name'] ?? 'Unknown',
      imageUrl: 'http://92.112.194.129:3000/${json['image'] ?? ''}',
      color: json['color'] ?? 'Unknown',
      size: json['size'] ?? 'Unknown',
      sizeId: json['_id'] ?? '', // Parse sizeId from JSON
      quantity: int.tryParse(json['quantity'] ?? '0') ?? 0,
      price: json['price'] ?? 'N/A',
    );
  }
}

class ProductPage2 extends StatelessWidget {
  final Balloon baloon;

  ProductPage2({required this.baloon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Breadcrumbs(),
              SizedBox(height: 20),
              ResponsiveLayout(
                mobileLayout: MobileProductLayout(baloon: baloon),
                desktopLayout: DesktopProductLayout(baloon: baloon),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Breadcrumbs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      'Brands / Kenzo / Mini Tiger Backpack in Neoprene',
      style: GoogleFonts.lato(fontSize: 14, color: Colors.grey),
    );
  }
}

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileLayout;
  final Widget desktopLayout;

  const ResponsiveLayout({
    required this.mobileLayout,
    required this.desktopLayout,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 768) {
          return mobileLayout;
        } else {
          return desktopLayout;
        }
      },
    );
  }
}

class MobileProductLayout extends StatelessWidget {
  final Balloon baloon;

  MobileProductLayout({required this.baloon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProductImage(imageUrl: baloon.imageUrl),
        SizedBox(height: 20),
        ProductDetails(baloon: baloon),
      ],
    );
  }
}

class DesktopProductLayout extends StatelessWidget {
  final Balloon baloon;

  DesktopProductLayout({required this.baloon});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: ProductImage(imageUrl: baloon.imageUrl)),
        SizedBox(width: 20),
        Expanded(child: ProductDetails(baloon: baloon)),
      ],
    );
  }
}

class ProductImage extends StatelessWidget {
  final String imageUrl;

  ProductImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      height: 400,
      width: 400,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Icon(Icons.error);
      },
    );
  }
}

class ProductDetails extends StatefulWidget {
  final Balloon baloon;

  ProductDetails({required this.baloon});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  String selectedSize = 'M';
  String selectedSizeId = ''; // Added to store the selected sizeId
  String selectedPrice = 'N/A';
  int quantity = 1;
  List<Map<String, dynamic>> availableSizes = [];
  List<dynamic>? userCart;

  @override
  void initState() {
    super.initState();
    _fetchSizes();
  }

  Future<void> _fetchSizes() async {
    try {
      final response = await http.post(
        Uri.parse('http://92.112.194.129:3000/get-sizes'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'baloonId': widget.baloon.id}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is List) {
          setState(() {
            availableSizes = List<Map<String, dynamic>>.from(data);
            if (availableSizes.isNotEmpty) {
              selectedSize = availableSizes[0]['size'];
              selectedSizeId = availableSizes[0]['_id']; // Capture sizeId
              selectedPrice = availableSizes[0]['price'];
            }
          });
        } else {
          throw FormatException('Expected a list, but got: ${data.runtimeType}');
        }
      } else {
        print('Failed to load sizes. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _onSizeSelected(String size) {
    setState(() {
      selectedSize = size;
      final selectedSizeData = availableSizes.firstWhere((element) => element['size'] == size);
      selectedSizeId = selectedSizeData['_id']; // Capture sizeId
      selectedPrice = selectedSizeData['price'];
    });
  }

  void _updateQuantity(int change) {
    setState(() {
      quantity = (quantity + change).clamp(1, 100);
    });
  }

  void _addToCart() {
    final Map<String, dynamic> cartItem = {
      'accessId': null,
      'baloonId': widget.baloon.id,
      'sizeId': selectedSizeId, // Include sizeId in the cart
      'quantity': quantity.toString(),
      'image': widget.baloon.imageUrl,
      'description': widget.baloon.name,
      'price': selectedPrice.toString(),
      'size': selectedSize,
    };

    // Get existing cart from local storage
    String? existingCart = html.window.localStorage['userCart'];
    userCart = existingCart != null ? jsonDecode(existingCart) : [];

    // Check if the user already has a cart
    int userIndex = userCart!.indexWhere((cart) => cart['userId'] == html.window.localStorage['userId']);

    if (userIndex != -1) {
      // User already has a cart, update it
      userCart![userIndex]['carts'].add(cartItem);
    } else {
      // User doesn't have a cart, create a new one
      userCart!.add({
        'userId': html.window.localStorage['userId'],
        'status': 'pending',
        'carts': [cartItem],
      });
    }

    // Save updated cart to local storage
    html.window.localStorage['userCart'] = jsonEncode(userCart);
print(userCart);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Item added to cart!')));
  }

  void _orderNow() async {
    double totalPrice = 0.0;

    // Step 1: Process the cart items
    for (var item in userCart!) {
      double price = double.tryParse(item['price'] ?? '0') ?? 0;
      int quantity = int.tryParse(item['quantity'] ?? '0') ?? 0;

      // Calculate total price
      totalPrice += price * quantity;
    }

    // Step 2: Prepare the data according to the API requirements
    List<Map<String, dynamic>> preparedCarts = userCart!.map((item) {
      return {
        'accessId': item['accessId'],
        'baloonId': item['baloonId'],
        'sizeId': item['sizeId'], // Include sizeId in the order
        'quantity': item['quantity'],
      };
    }).toList();

    final Map<String, dynamic> orderData = {
      'userId': html.window.localStorage['userId'],
      'status': 'pending',
      'carts': preparedCarts,
    };

    try {
      final response = await http.post(
        Uri.parse('http://92.112.194.129:3000/store-order-mobile'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(orderData),
      );

      if (response.statusCode == 200) {
        print("Order placed successfully");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order placed successfully!')));

        setState(() {
          userCart!.clear();
        });

        String? userId = html.window.localStorage['userId'];
        String? cartData = html.window.localStorage['userCart'];
        List<dynamic> carts = cartData != null ? jsonDecode(cartData) : [];
        int userIndex = carts.indexWhere((cart) => cart['userId'] == userId);

        if (userIndex != -1) {
          carts[userIndex]['carts'] = userCart;
        }

        html.window.localStorage['userCart'] = jsonEncode(carts);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to place order.')));
        print('Order failed: ${response.body}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred')));
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = double.tryParse(selectedPrice) != null
        ? double.parse(selectedPrice) * quantity
        : 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.baloon.name.isNotEmpty ? widget.baloon.name : 'Unknown',
          style: GoogleFonts.lato(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          'Description not available',
          style: GoogleFonts.lato(fontSize: 16),
        ),
        SizedBox(height: 10),
        Text(
          'Color: ${widget.baloon.color.isNotEmpty ? widget.baloon.color : 'Unknown'}',
          style: GoogleFonts.lato(fontSize: 16, color: Colors.blue),
        ),
        SizedBox(height: 5),
        Text(
          'Size: $selectedSize',
          style: GoogleFonts.lato(fontSize: 16, color: Colors.grey),
        ),
        SizedBox(height: 10),
        Text(
          '\$$totalPrice',
          style: GoogleFonts.lato(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(
          '(Additional tax may apply on checkout)',
          style: GoogleFonts.lato(fontSize: 14, color: Colors.grey),
        ),
        SizedBox(height: 20),
        Text(
          'Select color:',
          style: GoogleFonts.lato(fontSize: 16),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            ColorOption(Colors.black),
            SizedBox(width: 10),
            ColorOption(Colors.brown),
          ],
        ),
        SizedBox(height: 20),
        Text(
          'Select size:',
          style: GoogleFonts.lato(fontSize: 16),
        ),
        SizedBox(height: 10),
        SizeSelector(
          availableSizes: availableSizes,
          selectedSize: selectedSize,
          onChanged: _onSizeSelected,
        ),
        SizedBox(height: 20),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () => _updateQuantity(-1),
            ),
            Text(
              '$quantity',
              style: GoogleFonts.lato(fontSize: 16),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => _updateQuantity(1),
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _addToCart,
                child: Text(
                  'Add to Cart',
                  style: GoogleFonts.lato(fontSize: 18, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF055C9D),
                  minimumSize: Size(140, 50),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: _orderNow,
                child: Text(
                  'Buy Now',
                  style: GoogleFonts.lato(fontSize: 18, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF055C9D),
                  minimumSize: Size(140, 50),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class ColorOption extends StatelessWidget {
  final Color color;

  const ColorOption(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey),
      ),
    );
  }
}

class SizeSelector extends StatelessWidget {
  final List<Map<String, dynamic>> availableSizes;
  final String selectedSize;
  final ValueChanged<String> onChanged;

  const SizeSelector({
    required this.availableSizes,
    required this.selectedSize,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return availableSizes.isNotEmpty
        ? Row(
            children: availableSizes.map((sizeInfo) {
              String size = sizeInfo['size'];
              return GestureDetector(
                onTap: () => onChanged(size),
                child: Container(
                  margin: EdgeInsets.only(right: 10),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: selectedSize == size ? Color(0xFF055C9D) : Colors.transparent,
                    border: Border.all(color: Color(0xFF055C9D)),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    size,
                    style: GoogleFonts.lato(
                      color: selectedSize == size ? Colors.white : Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            }).toList(),
          )
        : Text(
            'No sizes available',
            style: GoogleFonts.lato(fontSize: 16, color: Colors.red),
          );
  }
}
