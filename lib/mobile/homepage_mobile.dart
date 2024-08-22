
import 'package:baloonproject/mobile/foill_baloons_mobile.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class HomeScreenMobile extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreenMobile> with SingleTickerProviderStateMixin {
  int _selectedDrawerIndex = 0;

  final List<Widget> _screens = [
    FoilBalloonScreenMobile(),
    Screen2(),
    Screen3(),
    Screen4(),
    Screen5(),
    Screen6(),
    Screen7(),
  ];

  final List<String> _titles = [
    "Foil Balloons",
    "Latex Balloons",
    "Accessories",
    "My Account",
    "About Us",
    "Privacy Policy",
    "Contact Us",
  ];

  _getDrawerItemWidget(int pos) {
    return _screens[pos];
  }

  _onSelectItem(int index) {
    setState(() {
      _selectedDrawerIndex = index;
    });
    Navigator.of(context).pop(); // Close the drawer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
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
            Image.asset('assets/logo.png', height: 50), // Add your logo here
            IconButton(
              icon: Icon(Icons.shopping_cart, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Center(
                child: Image.asset('assets/logo.png', height: 100), // Add your logo here
              ),
            ),
            ListTile(
              leading: Icon(Icons.local_activity),
              title: Text('Foil Balloons'),
              onTap: () => _onSelectItem(0),
            ),
            ListTile(
              leading: Icon(Icons.local_activity),
              title: Text('Latex Balloons'),
              onTap: () => _onSelectItem(1),
            ),
            ListTile(
              leading: Icon(Icons.category),
              title: Text('Accessories'),
              onTap: () => _onSelectItem(2),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('My Account'),
              onTap: () => _onSelectItem(3),
            ),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About Us'),
              onTap: () => _onSelectItem(4),
            ),
            ListTile(
              leading: Icon(Icons.privacy_tip),
              title: Text('Privacy Policy'),
              onTap: () => _onSelectItem(5),
            ),
            ListTile(
              leading: Icon(Icons.contact_mail),
              title: Text('Contact Us'),
              onTap: () => _onSelectItem(6),
            ),
          ],
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}


class Screen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Latex Balloons Screen"),
    );
  }
}

class Screen3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Accessories Screen"),
    );
  }
}

class Screen4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("My Account Screen"),
    );
  }
}

class Screen5 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("About Us Screen"),
    );
  }
}

class Screen6 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Privacy Policy Screen"),
    );
  }
}

class Screen7 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Contact Us Screen"),
    );
  }
}
