import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FoilBalloonScreenMobile extends StatefulWidget {
  @override
  _FoilBalloonScreenState createState() => _FoilBalloonScreenState();
}

class _FoilBalloonScreenState extends State<FoilBalloonScreenMobile> {
  int _current = 0;
  bool dropdownOpen = false;
  String? selectedColor;

  final List<String> imgList = [
    'https://static.vecteezy.com/system/resources/previews/029/285/288/original/one-balloon-one-balloon-one-balloon-clipart-transparent-background-ai-generative-free-png.png',
  ];

  final List<Map<String, String>> colors = [
    {'color': 'BABY BLUE', 'id': '#805108'},
    {'color': 'BABY PINK', 'id': '#805109'},
    {'color': 'BLACK', 'id': '#000000'},
    {'color': 'BLUE', 'id': '#0000FF'},
    {'color': 'GOLD', 'id': '#FFD700'},
    {'color': 'MAGENTA', 'id': '#FF00FF'},
    {'color': 'PURPLE', 'id': '#800080'},
    {'color': 'RED', 'id': '#FF0000'},
    {'color': 'ROSE GOLD', 'id': '#B76E79'},
    {'color': 'SILVER', 'id': '#C0C0C0'},
    {'color': 'WHITE', 'id': '#FFFFFF'},
  ];

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
    body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              Column(
                children: [
                  Image.network(
                    'https://i0.wp.com/www.aceinternationaltrading.com/wp-content/uploads/2023/12/5-051-CARAMEL-ORANGE.png?resize=600%2C389&ssl=1',
                    fit: BoxFit.cover,
                    height: 400,
                  ),
                  SizedBox(width: 20),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '5″ #010 RED – 100PCS/BAG',
                          style: GoogleFonts.lato(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Login to view price',
                          style: GoogleFonts.lato(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Image.asset('assets/images/logo.jpg', height: 50),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Suggested Retail: \$7.99',
                                  style: GoogleFonts.lato(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '• Inner-bag (12 bags)',
                                  style: GoogleFonts.lato(
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  '• Master Case (96 bags)',
                                  style: GoogleFonts.lato(
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Text(
                          'SKU: 6973998050019',
                          style: GoogleFonts.lato(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'CATEGORY: STANDARD COLOR',
                          style: GoogleFonts.lato(
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Size',
                          style: GoogleFonts.lato(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        DropdownButton<String>(
                          value: selectedColor,
                          hint: Text('Select Color'),
                          items: colors.map((color) {
                            return DropdownMenuItem<String>(
                              value: color['color'],
                              child: Row(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: _getColorFromHex(color['id']!),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(color['color']!),
                                ],
                              ),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              selectedColor = newValue;
                            });
                          },
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF055C9D),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Add to Cart',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF055C9D),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Buy Now',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}