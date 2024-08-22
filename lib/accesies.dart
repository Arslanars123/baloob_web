import 'dart:convert';
import 'package:baloonproject/accesories_details.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:http/http.dart' as http;

class Accessory {
  final String id;
  final String name;
  final String imageUrl;
  final String description;
  final String description2;
  final double price;
  final int quantity;

  Accessory({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.description,
    required this.description2,
    required this.price,
    required this.quantity,
  });

  factory Accessory.fromJson(Map<String, dynamic> json) {
    return Accessory(
      id: json['_id'] ?? '',  // Parsing id
      name: json['name'] ?? 'Unknown',
      imageUrl: json['image'] != null
          ? 'http://92.112.194.129:3000/${json['image']}'
          : 'https://via.placeholder.com/150',
      description: json['description'] ?? 'No description available.',
      description2: json['description2'] ?? '',  // Parsing the second description
      price: json['price'] != null ? double.tryParse(json['price']) ?? 0.0 : 0.0,  // Parsing price as double
      quantity: json['quantity'] != null ? int.tryParse(json['quantity']) ?? 0 : 0,  // Parsing quantity as int
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
                      .map((accessory) => AccessoryCard(accessorys: accessory))
                      .toList(),
                ),
              ),
            ),
    );
  }
}

class AccessoryCard extends StatelessWidget {
  final Accessory accessorys;

  AccessoryCard({required this.accessorys});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
         Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProductPage3(accessory: this.accessorys,)),
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
              accessorys.imageUrl,
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
                accessorys.name,
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            Center(
              child: HtmlWidget(
                accessorys.description,
                textStyle: GoogleFonts.lato(fontSize: 14),
              ),
            ),
            Flexible(
              child: Text(
                '\$${accessorys.price.toStringAsFixed(2)}',
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
