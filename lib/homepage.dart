// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';

// import 'package:carousel_slider/carousel_slider.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: MyHomePage(),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
//   late TabController _tabController;


//   final List<String> imgList = [
//     'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRVhSi1G18qN0iLHrQBlZN_DNwudxOkkZG7qQ&s',
//   "https://t3.ftcdn.net/jpg/01/75/83/84/360_F_175838474_YJbSWhR3s7MbsfQu6plGXY6U0EsoSspq.jpg",
//   'https://example.com/your_image3.png', // Add more image URLs as needed
//   ];

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 6, vsync: this);
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 1,
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Row(
//               children: [
//                 Image.asset('assets/images/logo.jpg', height: 50), // Ensure you have the logo image in your assets
//                 SizedBox(width: 10),
//                 Text(
//                   "Mama's Favorite",
//                   style: GoogleFonts.lato(
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//             Row(
//               children: [
//                 IconButton(
//                   icon: Icon(Icons.search, color: Colors.black),
//                   onPressed: () {},
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.account_circle, color: Colors.black),
//                   onPressed: () {},
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.only(right: 16.0),
//                   child: Center(
//                     child: Text(
//                       '\$0.00',
//                       style: GoogleFonts.lato(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ),
//                 IconButton(
//                   icon: Icon(Icons.shopping_cart, color: Colors.black),
//                   onPressed: () {},
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Stack(
//               children: [
//                 CarouselSlider(
//                   items: imgList.map((item) => Container(
//                     child: Image.network(
//                       item,
//                       fit: BoxFit.cover,
//                       width: double.infinity,
//                     ),
//                   )).toList(),
//                   carouselController: _carouselController,
//                   options: CarouselOptions(
//                     height: 300,
//                     enlargeCenterPage: true,
//                     autoPlay: true,
//                     aspectRatio: 16/9,
//                     onPageChanged: (index, reason) {
//                       setState(() {
//                         // Handle page change if needed
//                       });
//                     }
//                   ),
//                 ),
//                 Positioned(
//                   left: 10,
//                   top: 130,
//                   child: IconButton(
//                     icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
//                     onPressed: () {
//                       _carouselController.previousPage();
//                     },
//                   ),
//                 ),
//                 Positioned(
//                   right: 10,
//                   top: 130,
//                   child: IconButton(
//                     icon: Icon(Icons.arrow_forward, color: Colors.white, size: 30),
//                     onPressed: () {
//                       _carouselController.nextPage();
//                     },
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             Center(
//               child: Container(
//                 color: Colors.white,
//                 child: Container(
//                   width: MediaQuery.of(context).size.width / 1.6,
//                   child: TabBar(
//                     controller: _tabController,
//                     isScrollable: true,
//                     indicatorColor: Colors.orange,
//                     labelColor: Colors.orange,
//                     unselectedLabelColor: Colors.black,
//                     labelStyle: GoogleFonts.lato(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     unselectedLabelStyle: GoogleFonts.lato(
//                       fontSize: 14,
//                       fontWeight: FontWeight.normal,
//                     ),
//                     tabs: [
//                       Tab(text: 'FOIL BALLOONS'),
//                       Tab(text: 'LATEX BALLOONS'),
//                       Tab(text: 'ACCESSORIES'),
//                       Tab(text: 'ABOUT US'),
//                       Tab(text: 'CONTACT US'),
//                       Tab(text: 'MY ACCOUNT'),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             Container(
//               height: MediaQuery.of(context).size.height, // This makes sure the grid takes space within scroll view
//               child: TabBarView(
//                 controller: _tabController,
//                 children: [
//                   HomeContent(),
//                   Placeholder(),
//                   Placeholder(),
//                   Placeholder(),
//                   Placeholder(),
//                   Placeholder(),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class HomeContent extends StatelessWidget {
//   final List<Map<String, String>> products = [
//     {
//       'image': 'https://images.rawpixel.com/image_png_800/cHJpdmF0ZS9sci9pbWFnZXMvd2Vic2l0ZS8yMDIyLTA1L2pvYjkxMC1tcC0wNzZfMS5wbmc.png',
//       'name': '16" HEART BABY BLUE',
//       'id': '#805108'
//     },
//     {
//       'image': 'https://images.rawpixel.com/image_png_800/cHJpdmF0ZS9sci9pbWFnZXMvd2Vic2l0ZS8yMDIyLTA1L2pvYjkxMC1tcC0wNzZfMS5wbmc.png',
//       'name': '16" HEART BABY PINK',
//       'id': '#805109'
//     },
//     {
//       'image': 'https://images.rawpixel.com/image_png_800/cHJpdmF0ZS9sci9pbWFnZXMvd2Vic2l0ZS8yMDIyLTA1L2pvYjkxMC1tcC0wNzZfMS5wbmc.png',
//       'name': '16" HEART BLACK',
//       'id': '#805104'
//     },
//     {
//       'image': 'https://images.rawpixel.com/image_png_800/cHJpdmF0ZS9sci9pbWFnZXMvd2Vic2l0ZS8yMDIyLTA1L2pvYjkxMC1tcC0wNzZfMS5wbmc.png',
//       'name': '16" HEART BLUE',
//       'id': '#805106'
//     },
//     {
//       'image': 'https://images.rawpixel.com/image_png_800/cHJpdmF0ZS9sci9pbWFnZXMvd2Vic2l0ZS8yMDIyLTA1L2pvYjkxMC1tcC0wNzZfMS5wbmc.png',
//       'name': '16" HEART GOLD',
//       'id': '#805101'
//     },
//     {
//       'image': 'https://images.rawpixel.com/image_png_800/cHJpdmF0ZS9sci9pbWFnZXMvd2Vic2l0ZS8yMDIyLTA1L2pvYjkxMC1tcC0wNzZfMS5wbmc.png',
//       'name': '16" HEART MAGENTA',
//       'id': '#805107'
//     },
//     {
//       'image': 'https://images.rawpixel.com/image_png_800/cHJpdmF0ZS9sci9pbWFnZXMvd2Vic2l0ZS8yMDIyLTA1L2pvYjkxMC1tcC0wNzZfMS5wbmc.png',
//       'name': '16" HEART PURPLE',
//       'id': '#805110'
//     },
//     {
//       'image': 'https://images.rawpixel.com/image_png_800/cHJpdmF0ZS9sci9pbWFnZXMvd2Vic2l0ZS8yMDIyLTA1L2pvYjkxMC1tcC0wNzZfMS5wbmc.png',
//       'name': '16" HEART RED',
//       'id': '#805105'
//     },
//     {
//       'image': 'https://images.rawpixel.com/image_png_800/cHJpdmF0ZS9sci9pbWFnZXMvd2Vic2l0ZS8yMDIyLTA1L2pvYjkxMC1tcC0wNzZfMS5wbmc.png',
//       'name': '16" HEART ROSE GOLD',
//       'id': '#805103'
//     },
//     {
//       'image': 'https://images.rawpixel.com/image_png_800/cHJpdmF0ZS9sci9pbWFnZXMvd2Vic2l0ZS8yMDIyLTA1L2pvYjkxMC1tcC0wNzZfMS5wbmc.png',
//       'name': '16" HEART SILVER',
//       'id': '#805102'
//     },
//     {
//       'image': 'https://images.rawpixel.com/image_png_800/cHJpdmF0ZS9sci9pbWFnZXMvd2Vic2l0ZS8yMDIyLTA1L2pvYjkxMC1tcC0wNzZfMS5wbmc.png',
//       'name': '16" HEART WHITE',
//       'id': '#805111'
//     },
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Text(
//             'NEW ITEMS!',
//             textAlign: TextAlign.center,
//             style: GoogleFonts.lato(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//               color: Colors.red,
//             ),
//           ),
//         ),
//         GridView.builder(
//           shrinkWrap: true,
//           physics: NeverScrollableScrollPhysics(),
//           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 4,
//             childAspectRatio: 0.75, // Adjust the aspect ratio to reduce height
//             mainAxisSpacing: 10,
//             crossAxisSpacing: 10,
//           ),
//           itemCount: products.length,
//           itemBuilder: (context, index) {
//             final product = products[index];
//             return Card(
//               elevation: 1,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start, // Align items to the start
//                 children: [
//                   Image.network(
//                     product['image']!,
//                     height: 80,
//                     fit: BoxFit.cover,
//                   ),
//                   SizedBox(height: 5),
//                   Text(
//                     product['name']!,
//                     textAlign: TextAlign.center,
//                     style: GoogleFonts.lato(
//                       fontSize: 12, // Reduced font size
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Text(
//                     product['id']!,
//                     style: GoogleFonts.lato(
//                       fontSize: 10, // Reduced font size
//                       color: Colors.grey,
//                     ),
//                   ),
//                   SizedBox(height: 5),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       Text(
//                         "Login to view price",
//                         style: GoogleFonts.lato(
//                           fontSize: 10, // Reduced font size
//                           color: Colors.red,
//                         ),
//                       ),
//                       Text(
//                         "Read more",
//                         style: GoogleFonts.lato(
//                           fontSize: 10, // Reduced font size
//                           color: Colors.black,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }
// }
