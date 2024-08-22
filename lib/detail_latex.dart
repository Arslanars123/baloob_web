import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Balloon App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DetailLatex(),
    );
  }
}

class DetailLatex extends StatelessWidget {
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
            Image.asset(
              'assets/images/logo.jpg',
              height: 150, // Adjust the logo height as needed
              fit: BoxFit.cover,
            ),
            IconButton(
              icon: Icon(Icons.shopping_cart, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
        toolbarHeight: 150, // Set the height of the AppBar
      ), body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 1,
              child: Image.network(
                'https://i0.wp.com/www.aceinternationaltrading.com/wp-content/uploads/2023/12/5-051-CARAMEL-ORANGE.png?resize=600%2C389&ssl=1',
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 20),
            Flexible(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '5″ #010 RED – 100PCS/BAG',
                    style: GoogleFonts.lato(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Login to view price',
                    style: GoogleFonts.lato(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Image.asset('assets/images/logo.jpg', height: 50), // Ensure you have the logo image in your assets
                      SizedBox(width: 10),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Suggested Retail: \$7.99',
                              style: GoogleFonts.lato(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            
                              maxLines: 2,
                            ),
                            Text(
                              '• Inner-bag (12 bags)',
                              style: GoogleFonts.lato(
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            Text(
                              '• Master Case (96 bags)',
                              style: GoogleFonts.lato(
                                fontSize: 16,
                              ),
                             
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    'SKU: 6973998050019',
                    style: GoogleFonts.lato(
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  Text(
                    'CATEGORY: STANDARD COLOR',
                    style: GoogleFonts.lato(
                      fontSize: 16,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
