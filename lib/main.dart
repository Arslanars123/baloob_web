import 'dart:convert';
import 'package:baloonproject/accesies.dart';
import 'package:baloonproject/latex.dart';
import 'package:baloonproject/myaccount.dart';
import 'package:baloonproject/product_foil.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  bool isLoggedIn = false;
  String? userName;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
    _pageController = PageController();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    var loggedIn = html.window.localStorage['isLoggedIn'];
    var name = html.window.localStorage['userName'];
    if (loggedIn != null && loggedIn == 'true') {
      setState(() {
        isLoggedIn = true;
        userName = name;
      });
    }
  }

  void _logout() {
    html.window.localStorage.remove('isLoggedIn');
    html.window.localStorage.remove('userName');
    setState(() {
      isLoggedIn = false;
      userName = null;
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MyHomePage()),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Foil Balloons'),
    Tab(text: 'Latex Balloons'),
    Tab(text: 'Accessories'),
    Tab(text: 'About Us'),
    Tab(text: 'Contact Us'),
    Tab(text: 'My Account'),
  ];

  final List<String> imgList = [
    "https://media.gettyimages.com/id/96622074/photo/party-house.jpg?s=612x612&w=gi&k=20&c=f0fV-_w31bPy9i2JvwITzE0JwQP7z8ubUkSy8ubWCeo=",
  ];

  int _current = 0;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Container(
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.facebook, color: Colors.black),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.camera, color: Colors.black),
                    onPressed: () {},
                  ),
                ],
              ),
              Image.asset(
                'assets/images/logo.jpg',
                height: 120, // Adjust the logo height as needed
                fit: BoxFit.cover,
              ),
              InkWell(
                onTap: () {
                  isLoggedIn ? _logout() : _showLoginDialog();
                },
                child: Text(isLoggedIn ? "Logout" : "Login"),
              ),
            ],
          ),
        ),
        toolbarHeight: 120, // Set the height of the AppBar
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            width > 1280
                ? Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.0), // Optional: Add some horizontal padding
                      child: Container(
                        color: Colors.transparent,
                        constraints: BoxConstraints(
                          maxWidth: 1000, // Optional: Set a maximum width for the TabBar container
                        ),
                        child: Card(
                          elevation: 2,
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 30),
                            child: TabBar(
                              dividerColor: Colors.transparent,
                              controller: _tabController,
                              isScrollable: true,
                              indicatorColor: Colors.transparent,
                              labelColor: Color(0xFF055C9D),
                              unselectedLabelColor: Colors.grey.withOpacity(0.6),
                              labelStyle: GoogleFonts.lato(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                              unselectedLabelStyle: GoogleFonts.lato(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                              tabs: myTabs,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                : Column(
                    children: [
                      Wrap(
                        alignment: WrapAlignment.center,
                        children: myTabs.take(3).map((Tab tab) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _tabController.animateTo(myTabs.indexOf(tab));
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _tabController.index == myTabs.indexOf(tab)
                                      ? Color(0xFF055C9D)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                child: Text(
                                  tab.text!,
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                    fontWeight: _tabController.index == myTabs.indexOf(tab)
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: _tabController.index == myTabs.indexOf(tab)
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      Wrap(
                        alignment: WrapAlignment.center,
                        children: myTabs.skip(3).map((Tab tab) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _tabController.animateTo(myTabs.indexOf(tab));
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: _tabController.index == myTabs.indexOf(tab)
                                      ? Color(0xFF055C9D)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                child: Text(
                                  tab.text!,
                                  style: GoogleFonts.lato(
                                    fontSize: 14,
                                    fontWeight: _tabController.index == myTabs.indexOf(tab)
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    color: _tabController.index == myTabs.indexOf(tab)
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
            SizedBox(height: 20),
            Stack(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: imgList.length,
                    itemBuilder: (context, index) {
                      return Image.network(
                        imgList[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                      );
                    },
                    onPageChanged: (index) {
                      setState(() {
                        _current = index;
                      });
                    },
                  ),
                ),
                Positioned(
                  bottom: 10.0,
                  left: 0.0,
                  right: 0.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: imgList.map((url) {
                      int index = imgList.indexOf(url);
                      return Container(
                        width: 8.0,
                        height: 8.0,
                        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == index ? Colors.white : Colors.grey,
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Positioned(
                  top: 0.0,
                  bottom: 0.0,
                  left: 10.0,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white, size: 30.0),
                    onPressed: () {
                      _pageController.previousPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                    },
                  ),
                ),
                Positioned(
                  top: 0.0,
                  bottom: 0.0,
                  right: 10.0,
                  child: IconButton(
                    icon: Icon(Icons.arrow_forward, color: Colors.white, size: 30.0),
                    onPressed: () {
                      _pageController.nextPage(duration: Duration(milliseconds: 300), curve: Curves.easeIn);
                    },
                  ),
                ),
              ],
            ),
            Container(
              color: Colors.black,
              height: MediaQuery.of(context).size.height, // This makes sure the grid takes space within scroll view
              child: TabBarView(
                controller: _tabController,
                children: [
                  ProductFoil(),
                  BalloonTabScreen(),
                  AccessoriesScreen(),
                  AboutUsPage(),
                  ContactUsPage(),
                  AuthPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Login'),
          content: Text('Login dialog content here.'),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}


class ProductDetailPage extends StatefulWidget {
  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {

  int _current = 0;
  int _selectedSize = 0;
  int _selectedColor = 0;
  final List<String> imgList = [
    'https://static.vecteezy.com/system/resources/previews/029/285/288/original/one-balloon-one-balloon-one-balloon-clipart-transparent-background-ai-generative-free-png.png',
 ];

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   title:  Text(
      //       'NEW ITEMS!',
      //       textAlign: TextAlign.center,
      //       style: GoogleFonts.lato(
      //         color: Color(0xFF055C9D),
      //         fontSize: 24,
      //         fontWeight: FontWeight.bold,
              
      //       ),
      //     ),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          width: double.infinity,
          child: Center(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height/20,),
                Container(
                 
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Left side: image carousel and thumbnails
                      Container(
                        width: MediaQuery.of(context).size.width/2,
                        child: Column(
                          children: [
                         
                            // CarouselSlider(
                            //   options: CarouselOptions(
                            //     height: 400,
                            //     autoPlay: true,
                            //     enlargeCenterPage: true,
                            //     aspectRatio: 2.0,
                            //     onPageChanged: (index, reason) {
                            //       setState(() {
                            //         _current = index;
                            //       });
                            //     },
                            //   ),
                            //   items: imgList.map((item) => Container(
                            //     child: Center(
                            //       child: Image.network(item, fit: BoxFit.cover, height: 400),
                            //     ),
                            //   )).toList(),
                            // ),
                            SizedBox(height: 8),
                                          
                          ],
                        ),
                      ),
                      // Right side: product details
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                          
                            children: [
                              Text(
                                'Blazer Jacket',
                                style: GoogleFonts.lato(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                             
                              SizedBox(height: 8),
                              Text(
                                '\$2500',
                                style: GoogleFonts.lato(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Available Size',
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  _buildSizeOption('S', 0),
                                  _buildSizeOption('M', 1),
                                  _buildSizeOption('L', 2),
                                ],
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Available Color',
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  _buildColorOption(Colors.black, 0),
                                  _buildColorOption(Colors.grey, 1),
                                ],
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Last 1 left - make it yours!',
                                style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.red,
                                ),
                              ),
                              SizedBox(height: 16),
                              Row(
                                children: [
                                  _buildCounter(),
                                  SizedBox(width: 16),
                                  ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.black,
                                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                    ),
                                    child: Text(
                                      'Add to cart',
                                      style: GoogleFonts.lato(fontSize: 16),
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
      ),
    );
  }

  Widget _buildSizeOption(String size, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedSize = index;
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 8),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: _selectedSize == index ? Colors.black : Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(size, style: GoogleFonts.lato(fontSize: 16)),
      ),
    );
  }

  Widget _buildColorOption(Color color, int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedColor = index;
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 8),
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: _selectedColor == index ? Colors.black : Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: _selectedColor == index
            ? Icon(Icons.check, color: Colors.white)
            : Container(),
      ),
    );
  }

  Widget _buildCounter() {
    int _counter = 1;
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




class AboutUsPage extends StatefulWidget {
  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  String aboutContent = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAboutUsContent();
  }

  Future<void> _fetchAboutUsContent() async {
    try {
      final response = await http.post(
        Uri.parse('http://92.112.194.129:3000/get-about'),
        headers: {'Content-Type': 'application/json'},
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        if (data.isNotEmpty && data[0] is Map<String, dynamic>) {
          setState(() {
            aboutContent = data[0]['about'] ?? '<p>No content available.</p>';
            isLoading = false;
          });
        } else {
          throw FormatException('Unexpected response format');
        }
      } else {
        setState(() {
          isLoading = false;
        });
        print('Failed to load About Us content. Status code: ${response.statusCode}');
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
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height / 20),
              Text(
                'About Us',
                style: GoogleFonts.lato(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: HtmlWidget(
                        aboutContent,
                        textStyle: GoogleFonts.lato(fontSize: 16, color: Colors.black87),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContactUsPage extends StatelessWidget {
  final String phoneNumber = '+1 234 567 890';
  final String email = 'support@example.com';

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            children: [
              SizedBox(height: 40,),
              Container(
                width: width * 0.5,
                padding: const EdgeInsets.all(32.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10.0,
                      spreadRadius: 5.0,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Contact Us',
                      style: GoogleFonts.hind(
                        fontSize: 32.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    SizedBox(height: 24.0),
                    Row(
                      children: [
                        Icon(Icons.phone, color: Colors.blueAccent),
                        SizedBox(width: 10.0),
                        Text(
                          phoneNumber,
                          style: GoogleFonts.hind(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.0),
                    Row(
                      children: [
                        Icon(Icons.email, color: Colors.blueAccent),
                        SizedBox(width: 10.0),
                        Text(
                          email,
                          style: GoogleFonts.hind(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40.0),
                 ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




class ColorDropdownScreen extends StatefulWidget {
  @override
  _ColorDropdownScreenState createState() => _ColorDropdownScreenState();
}

class _ColorDropdownScreenState extends State<ColorDropdownScreen> {
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
  bool dropdownOpen = false;

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return Color(int.parse(hexColor, radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Color'),
      ),
      body: Center(
        child: Column(
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
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  selectedColor == null ? 'Dropdown button' : selectedColor!,
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (dropdownOpen)
              Container(
                width: 200,
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
                            selectedColor = color['id'];
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
      ),
    );
  }
}


class CustomDialog extends StatelessWidget {
  final VoidCallback onSignIn;
  final VoidCallback onLogOut;

  CustomDialog({required this.onSignIn, required this.onLogOut});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 16,
      backgroundColor: Colors.transparent,
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.only(top: 13),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: onSignIn,
                  child: Text('Sign In'),
                ),
                ElevatedButton(
                  onPressed: onLogOut,
                  child: Text('Log Out'),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 50,
            right: 50,
            child: CustomPaint(
              painter: ArrowPainter(),
              child: Container(height: 20),
            ),
          ),
        ],
      ),
    );
  }
}

class ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    var path = Path();
    path.moveTo(0, 20);
    path.lineTo(size.width / 2, 0);
    path.lineTo(size.width, 20);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
