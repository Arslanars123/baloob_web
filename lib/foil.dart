
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class HomeContent extends StatefulWidget {
  @override
  _HomeContentState createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final List<Map<String, String>> products = [
    {
      'image': 'https://thestationers.pk/cdn/shop/files/chrome-metallic-shiny-latex-balloons-11-inch-single-color-10-pcs-the-stationers-3.jpg?v=1708446284',
      'name': '16" HEART BABY BLUE',
      'id': '#805108'
    },
    // Add more products here
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

  String? selectedColor;

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  final TextEditingController searchController = TextEditingController();
  List<Map<String, String>> filteredProducts = [];
  Set<String> selectedProducts = {};
bool dropdownOpen = false;
  @override
  void initState() {
    super.initState();
    filteredProducts = products;
  }

  void filterSearch(String query) {
    final results = products.where((product) {
      final nameLower = product['name']!.toLowerCase();
      final queryLower = query.toLowerCase();
      return nameLower.contains(queryLower);
    }).toList();

    setState(() {
      filteredProducts = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height / 30),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'FOIL BALLOONS',
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
              color: Color(0xFF055C9D),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Image.network(
                    products.first['image']!,
                    height: MediaQuery.of(context).size.height / 2,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  products.first['name']!,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  products.first['id']!,
                  style: GoogleFonts.lato(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "Login to view price",
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        color: Color(0xFF055C9D),
                      ),
                    ),
                    Text(
                      "Selected: ${selectedProducts.length}",
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
          
              child: Column(
                children: [
                 
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
                height: MediaQuery.of(context).size.height/5,
              
                
               
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
                    children: colors.map((color) {
                      return InkWell(
                        onTap: () {
                          setState(() {
                            selectedColor = color['color'];
                            dropdownOpen = false;
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
                                  color: _getColorFromHex(color['id']!),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                color['color']!,
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
      
         ],
              ),
            ),
          ],
        ),
      ],
    );
  }



  int _calculateCrossAxisCount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 1300) return 4;
    if (screenWidth >= 900) return 3;
    if (screenWidth >= 600) return 2;
    return 1;
  }

  double _calculateChildAspectRatio(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 1200) return 1.5;
    if (screenWidth >= 900) return 1.3;
    if (screenWidth >= 600) return 1.2;
    return 1.0;
  }
}

