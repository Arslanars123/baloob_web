import 'package:baloonproject/accesies.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'dart:html' as html;
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class ProductPage3 extends StatelessWidget {
  final Accessory accessory;

  ProductPage3({required this.accessory});

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
                mobileLayout: MobileProductLayout(accessory: accessory),
                desktopLayout: DesktopProductLayout(accessory: accessory),
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
  final Accessory accessory;

  MobileProductLayout({required this.accessory});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ProductImage(imageUrl: accessory.imageUrl),
        SizedBox(height: 20),
        ProductDetails(accessory: accessory),
      ],
    );
  }
}

class DesktopProductLayout extends StatelessWidget {
  final Accessory accessory;

  DesktopProductLayout({required this.accessory});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: ProductImage(imageUrl: accessory.imageUrl)),
        SizedBox(width: 20),
        Expanded(child: ProductDetails(accessory: accessory)),
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
  final Accessory accessory;

  ProductDetails({required this.accessory});

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  int quantity = 1;
  List<dynamic>? userCart;


  @override
  void initState() {
    super.initState();
  }

  void _updateQuantity(int change) {
    setState(() {
      quantity = (quantity + change).clamp(1, 100);
    });
  }

  void _addToCart() {
    final Map<String, dynamic> cartItem = {
      'accessId': widget.accessory.id,
      'baloonId': null,
      'quantity': quantity.toString(),
      'image': widget.accessory.imageUrl,
      'description': widget.accessory.name,
      'price': widget.accessory.price.toString(),
    };

    String? existingCart = html.window.localStorage['userCart'];
    userCart = existingCart != null ? jsonDecode(existingCart) : [];

    int userIndex = userCart!.indexWhere((cart) => cart['userId'] == html.window.localStorage['userId']);

    if (userIndex != -1) {
      userCart![userIndex]['carts'].add(cartItem);
    } else {
      userCart!.add({
        'userId': html.window.localStorage['userId'],
        'status': 'pending',
        'carts': [cartItem],
      });
    }
    html.window.localStorage['userCart'] = jsonEncode(userCart);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Item added to cart!')));
  }

  void _buyNow() async {
    String? userId = html.window.localStorage['userId'];
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('User not logged in. Please login first.'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    double totalPrice = widget.accessory.price * quantity;

    final Map<String, dynamic> cartItem = {
      'accessId': widget.accessory.id,
      'baloonId': null,
      'quantity': quantity.toString(),
      'price': widget.accessory.price.toString(),
    };

    final Map<String, dynamic> orderData = {
      'userId': userId,
      'status': 'pending',
      'carts': [cartItem],
    };

    try {
      final response = await http.post(
        Uri.parse('http://92.112.194.129:3000/store-order-mobile'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(orderData),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        String orderId = responseBody['orderId'];

        String paymentUrl = 'http://92.112.194.129:3000/payment/$userId/$orderId/$totalPrice';

        if (await canLaunch(paymentUrl)) {
          await launch(paymentUrl);
        } else {
          throw 'Could not launch $paymentUrl';
        }
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
    double totalPrice = widget.accessory.price * quantity;
    print("prices");
    print(totalPrice);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.accessory.name.isNotEmpty ? widget.accessory.name : 'Unknown',
          style: GoogleFonts.lato(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          widget.accessory.description.isNotEmpty ? widget.accessory.description : 'Description not available',
          style: GoogleFonts.lato(fontSize: 16),
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
                onPressed: _buyNow,
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

class AccessoriesScreen extends StatefulWidget {
  @override
  _AccessoriesScreenState createState() => _AccessoriesScreenState();
}

class _AccessoriesScreenState extends State<AccessoriesScreen> {
  List<Accessory> accessories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAccessories();
  }

  Future<void> _fetchAccessories() async {
    try {
      final response = await http.post(
        Uri.parse('http://92.112.194.129:3000/get-access'),
        headers: {'Content-Type': 'application/json'},
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print(data);
        setState(() {
          accessories = data.map((json) => Accessory.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        print('Failed to load accessories. Status code: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Wrap(
                  spacing: 14, // Spacing between items in the main axis
                  runSpacing: 8.0, // Spacing between items in the cross axis
                  children: accessories
                      .map((accessory) => AccessoryCard(accessory: accessory))
                      .toList(),
                ),
              ),
            ),
    );
  }
}

class AccessoryCard extends StatelessWidget {
  final Accessory accessory;

  AccessoryCard({required this.accessory});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
         Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProductPage3(accessory: this.accessory,)),
            );
      },
      child: Container(
        width: 200, // Fixed width
        height: 260, // Fixed height
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.network(
              accessory.imageUrl,
              width: 130,
              height: 130,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error);
              },
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                accessory.name,
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: HtmlWidget(
                accessory.description,
                textStyle: GoogleFonts.lato(fontSize: 14),
              ),
            ),
            Flexible(
              child: Text(
                '\$${accessory.price.toStringAsFixed(2)}',
                style: GoogleFonts.lato(
                    color: Colors.red, fontSize: 14, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
