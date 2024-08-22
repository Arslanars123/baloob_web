import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class HomeScre extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScre> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    FoilBalloonsScreen(),
    LatexBalloonsScreen(),
    
  ];

  void _onDrawerItemTap(int index) {
    setState(() {
      _selectedIndex = index;
      Navigator.pop(context); // close the drawer
    });
  }
bool dropdownOpen= false;
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Balloon Store'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text('Menu', style: GoogleFonts.lato(fontSize: 24, color: Colors.white)),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Foil Balloons', style: GoogleFonts.lato(fontSize: 18)),
              onTap: () => _onDrawerItemTap(0),
            ),
            ListTile(
              title: Text('Latex Balloons', style: GoogleFonts.lato(fontSize: 18)),
              onTap: () => _onDrawerItemTap(1),
            ),
            ListTile(
              title: Text('Accessories', style: GoogleFonts.lato(fontSize: 18)),
              onTap: () => _onDrawerItemTap(2),
            ),
          ],
        ),
      ),
      body: _screens[_selectedIndex],
    );
  }
}

class FoilBalloonsScreen extends StatefulWidget {
  @override
  _FoilBalloonsScreenState createState() => _FoilBalloonsScreenState();
}

class _FoilBalloonsScreenState extends State<FoilBalloonsScreen> {
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
bool dropdownOpen= false;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;
        double imageSize = isMobile ? constraints.maxWidth * 0.8 : constraints.maxWidth * 0.3;
        double dropdownWidth = isMobile ? constraints.maxWidth * 0.9 : constraints.maxWidth * 0.4;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'FOIL BALLOONS',
                style: GoogleFonts.lato(
                  color: Color(0xFF055C9D),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          dropdownOpen = !dropdownOpen;
                        });
                      },
                      child: Container(
                        width: dropdownWidth,
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
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
                            Icon(Icons.arrow_drop_down),
                          ],
                        ),
                      ),
                    ),
                    if (dropdownOpen)
                      Container(
                        width: dropdownWidth,
                        height: 200,
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
                    SizedBox(height: 20),
                    Image.network(
                      'https://thestationers.pk/cdn/shop/files/chrome-metallic-shiny-latex-balloons-11-inch-single-color-10-pcs-the-stationers-3.jpg?v=1708446284',
                      height: imageSize,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 10),
                    Text(
                      '\$10.00',
                      style: GoogleFonts.lato(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class LatexBalloonsScreen extends StatefulWidget {
  @override
  _LatexBalloonsScreenState createState() => _LatexBalloonsScreenState();
}

class _LatexBalloonsScreenState extends State<LatexBalloonsScreen> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  bool dropdownOpen = false;
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Latex Balloons'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Standard Color'),
            Tab(text: 'Sub Standard Color'),
            Tab(text: 'Platinum Colors'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildTabContent(),
          _buildTabContent(),
          _buildTabContent(),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isMobile = constraints.maxWidth < 600;
        double imageSize = isMobile ? constraints.maxWidth * 0.8 : constraints.maxWidth * 0.3;
        double dropdownWidth = isMobile ? constraints.maxWidth * 0.9 : constraints.maxWidth * 0.4;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    dropdownOpen = !dropdownOpen;
                  });
                },
                child: Container(
                  width: dropdownWidth,
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
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
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
              ),
              if (dropdownOpen)
                Container(
                  width: dropdownWidth,
                  height: 200,
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
              SizedBox(height: 20),
              Image.network(
                'https://thestationers.pk/cdn/shop/files/chrome-metallic-shiny-latex-balloons-11-inch-single-color-10-pcs-the-stationers-3.jpg?v=1708446284',
                height: imageSize,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 10),
              Text(
                '\$10.00',
                style: GoogleFonts.lato(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

