import 'dart:convert';
import 'package:baloonproject/global.dart';
import 'package:baloonproject/main.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;

String? userId; // Global variable to store user ID

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
      home: AuthPage(),
    );
  }
}

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  PageController _pageController = PageController();
  bool isLoggedIn = false;
  String? userName;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    var loggedIn = html.window.localStorage['isLoggedIn'];
    var name = html.window.localStorage['userName'];
    var id = html.window.localStorage['userId']; // Retrieve user ID from local storage
    if (loggedIn != null && loggedIn == 'true') {
      setState(() {
        isLoggedIn = true;
        userName = name;
        userId = id; // Update global variable
      });
    }
  }

  void _goToSignUpPage() {
    _pageController.animateToPage(
      1,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  void _goToSignInPage() {
    _pageController.animateToPage(
      0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  void _logout() {
    html.window.localStorage.remove('isLoggedIn');
    html.window.localStorage.remove('userName');
    html.window.localStorage.remove('userId'); // Remove user ID from local storage
    setState(() {
      isLoggedIn = false;
      userName = null;
      userId = null; // Reset global variable
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
 
      body: isLoggedIn
          ? MyAccountPage()
          : PageView(
              controller: _pageController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                SignInPage(onSignUpTap: _goToSignUpPage, onLoginSuccess: _checkLoginStatus),
                SignUpPage(onSignInTap: _goToSignInPage),
              ],
            ),
    );
  }
}

class SignInPage extends StatefulWidget {
  final VoidCallback onSignUpTap;
  final VoidCallback onLoginSuccess;

  SignInPage({required this.onSignUpTap, required this.onLoginSuccess});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://92.112.194.129:3000/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        print(response.body.toString() + 'ss');
        if (response.body != null && response.body.isNotEmpty) {
          final data = jsonDecode(response.body);
          html.window.localStorage['isLoggedIn'] = 'true';
          html.window.localStorage['userName'] = data['name'];
          html.window.localStorage['userId'] = data['_id']; // Save user ID in local storage
          userId = data['_id']; // Update global variable
          widget.onLoginSuccess();
         isLoggedIn = true;
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyHomePage()),
          );
        } else {
          print('Response body is null or empty');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed')));
        }
      } else {
        print('Login failed: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login failed')));
      }
    } catch (e) {
      print('Error during login: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred')));
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Text(
                  'Sign In',
                  style: GoogleFonts.lato(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 24),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Username or email address',
                    labelStyle: GoogleFonts.lato(fontSize: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: GoogleFonts.lato(fontSize: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    suffixIcon: Icon(Icons.visibility),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Checkbox(value: false, onChanged: (bool? value) {}),
                    Text(
                      'Remember me',
                      style: GoogleFonts.lato(fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          'Log in',
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Lost your password?',
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: widget.onSignUpTap,
                  child: Text(
                    'Create an account',
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SignUpPage extends StatefulWidget {
  final VoidCallback onSignInTap;

  SignUpPage({required this.onSignInTap});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _register() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://92.112.194.129:3000/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': _nameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration successful')));
        widget.onSignInTap();
      } else {
        print('Registration failed: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Registration failed')));
      }
    } catch (e) {
      print('Error during registration: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred')));
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 600),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Text(
                  'Create Account',
                  style: GoogleFonts.lato(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 24),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    labelStyle: GoogleFonts.lato(fontSize: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email address',
                    labelStyle: GoogleFonts.lato(fontSize: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: GoogleFonts.lato(fontSize: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    suffixIcon: Icon(Icons.visibility),
                  ),
                ),
                SizedBox(height: 16),
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text(
                          'Sign Up',
                          style: GoogleFonts.lato(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: widget.onSignInTap,
                  child: Text(
                    'Already have an account? Sign In',
                    style: GoogleFonts.lato(
                      fontSize: 16,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}





class MyAccountPage extends StatefulWidget {
  @override
  _MyAccountPageState createState() => _MyAccountPageState();
}

class _MyAccountPageState extends State<MyAccountPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _logout() {
    html.window.localStorage.remove('isLoggedIn');
    html.window.localStorage.remove('userName');
    html.window.localStorage.remove('userId'); // Remove user ID from local storage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AuthPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Account', style: GoogleFonts.lato()),
        actions: [
          TextButton(
            onPressed: _logout,
            child: Text('Logout', style: GoogleFonts.lato(color: Colors.white)),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Color(0xFF055C9D),
                    labelColor: Color(0xFF055C9D),
                    unselectedLabelColor: Colors.black,
                    labelStyle: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    unselectedLabelStyle: GoogleFonts.lato(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
          tabs: [
            Tab(text: 'My Cart'),
            Tab(text: 'My Orders'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          MyCartScreen(),
          MyOrdersScreen(),
        ],
      ),
    );
  }
}

class MyCartScreen extends StatefulWidget {
  MyCartScreen({Key? key}) : super(key: key);

  @override
  _MyCartScreenState createState() => _MyCartScreenState();
}

class _MyCartScreenState extends State<MyCartScreen> {
  List<Map<String, dynamic>> cartItems = [];

  @override
  void initState() {
    super.initState();
    cartItems = _getCartItems();
  }

  List<Map<String, dynamic>> _getCartItems() {
    String? userId = html.window.localStorage['userId'];
    String? cartData = html.window.localStorage['userCart'];

    if (cartData != null) {
      List<dynamic> carts = jsonDecode(cartData);
      print("see carts here");
      print(carts);
      Map<String, dynamic>? userCart = carts.firstWhere(
        (cart) => cart['userId'] == userId,
        orElse: () => null,
      );
      print("here is data of carts");
      print(userCart);
      if (userCart != null) {
        return List<Map<String, dynamic>>.from(userCart['carts']);
      }
      
    }
   
    return [];
  }

  void _updateQuantity(int index, int change) {
    setState(() {
      int currentQuantity = int.parse(cartItems[index]['quantity']);
      int newQuantity = currentQuantity + change;

      if (newQuantity > 0) {
        cartItems[index]['quantity'] = newQuantity.toString();
      } else {
        // If the quantity becomes 0 or less, remove the item from the cart
        cartItems.removeAt(index);
      }
    });
    _saveCart();
  }

  void _saveCart() {
    String? userId = html.window.localStorage['userId'];
    String? cartData = html.window.localStorage['userCart'];

    List<dynamic> carts = cartData != null ? jsonDecode(cartData) : [];
    int userIndex = carts.indexWhere((cart) => cart['userId'] == userId);

    if (userIndex != -1) {
      carts[userIndex]['carts'] = cartItems;
    }

    html.window.localStorage['userCart'] = jsonEncode(carts);
  }

  // void _orderNow() async {
  //   List<Map<String, dynamic>> newArray = cartItems.map((item) {
  //     return {
  //       'accessId': item['accessId'],  // Include accessId as is, which can be null
  //       'baloonId': item['baloonId'] ?? '',
  //       'quantity': item['quantity'] ?? ''
  //     };
  //   }).toList();

  //   final Map<dynamic, dynamic> orderData = {
  //     'userId': html.window.localStorage['userId'],
  //     'status': 'pending',
  //     'carts': newArray,
  //   };

  //   try {
  //     final response = await http.post(
  //       Uri.parse('http://92.112.194.129:3000/store-order-mobile'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode(orderData),
  //     );
  //     print(html.window.localStorage['userId'].toString());
  //     print(cartItems);
  //     if (response.statusCode == 200) {
  //       print("Order placed successfully");
  //       print(response.body);
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order placed successfully!')));

  //       // Clear the cart items
  //       setState(() {
  //         cartItems.clear();
  //       });

  //       // Update local storage
  //       String? userId = html.window.localStorage['userId'];
  //       String? cartData = html.window.localStorage['userCart'];
  //       List<dynamic> carts = cartData != null ? jsonDecode(cartData) : [];
  //       int userIndex = carts.indexWhere((cart) => cart['userId'] == userId);

  //       if (userIndex != -1) {
  //         carts[userIndex]['carts'] = cartItems;  // This will be an empty list
  //       }

  //       html.window.localStorage['userCart'] = jsonEncode(carts);
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to place order.')));
  //       print('Order failed: ${response.body}');
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred')));
  //     print('Error: $e');
  //   }
  // }
void _orderNow() async {
  // Step 1: Validate all prices in the cart items
  for (var item in cartItems) {
    double? price = double.tryParse(item['price'] ?? '');
    if (price == null) {
      // If any price is not a valid number, show an error and return
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: Invalid price detected in the cart. Please check your items.'),
        backgroundColor: Colors.red,
      ));
      return; // Stop further execution
    }
  }

  double totalPrice = 0.0;
  List<Map<String, dynamic>> balloonSizeList = [];
  List<Map<String, dynamic>> optionalFieldsList = [];

  // Step 2: Process the cart items
  for (int index = 0; index < cartItems.length; index++) {
    var item = cartItems[index];
    
    // Check if the item is a balloon or accessory
    String? baloonId = item['baloonId'];
    String? accessId = item['accessId'];
    String? size = item['size'];
    double price = double.tryParse(item['price'] ?? '0') ?? 0;
    int quantity = int.tryParse(item['quantity'] ?? '0') ?? 0;

    // Calculate total price
    totalPrice += price * quantity;

    // Save sizes, baloonId, and index in a separate array
    if (baloonId != null && baloonId.isNotEmpty) {
      // Check if this baloonId already exists in the balloonSizeList
      Map<String, dynamic>? balloonEntry = balloonSizeList.firstWhere(
        (entry) => entry['baloonId'] == baloonId,
        orElse: () => {},
      );

      if (balloonEntry.isNotEmpty) {
        // If the baloonId exists, add the size to the list if it's not empty
        if (size != null && size.isNotEmpty) {
          balloonEntry['sizes'].add(size);
        }
      } else {
        // If the baloonId doesn't exist, create a new entry
        balloonSizeList.add({
          'baloonId': baloonId,
          'sizes': size != null && size.isNotEmpty ? [size] : [],
          'index': index,  // Save the index number
        });
      }
    }

    // Extract and store the optional fields in a separate list
    optionalFieldsList.add({
      'image': item['image'],
      'description': item['description'],
      'price': item['price'],
      'size': item['size'],
    });

    // Remove the optional fields from the original item
    item.remove('image');
    item.remove('description');
    item.remove('price');
    item.remove('size');
  }

  // Output the results for debugging purposes
  print("Total Price: \$${totalPrice.toStringAsFixed(2)}");
  print("Balloon Size List: $balloonSizeList");
  print("Optional Fields List: $optionalFieldsList");

  // Step 3: Prepare the data according to the API requirements
  List<Map<String, dynamic>> preparedCarts = cartItems.map((item) {
    return {
      'accessId': item['accessId'],  // Keep accessId if it exists
      'baloonId': item['baloonId'],  // Keep baloonId if it exists
      'quantity': item['quantity'],  // Quantity is required
    };
  }).toList();

  final Map<String, dynamic> orderData = {
    'userId': html.window.localStorage['userId'],
    'status': 'pending',
    'carts': preparedCarts,
  };

  try {
    // Step 4: Send the API request
    final response = await http.post(
      Uri.parse('http://92.112.194.129:3000/store-order-mobile'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(orderData),
    );

    if (response.statusCode == 200) {
      print("Order placed successfully");
      print(response.body);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order placed successfully!')));

      // Clear the cart items after successful order
      setState(() {
        cartItems.clear();
      });

      // Update local storage to reflect the empty cart
      String? userId = html.window.localStorage['userId'];
      String? cartData = html.window.localStorage['userCart'];
      List<dynamic> carts = cartData != null ? jsonDecode(cartData) : [];
      int userIndex = carts.indexWhere((cart) => cart['userId'] == userId);

      if (userIndex != -1) {
        carts[userIndex]['carts'] = cartItems;  // Clear the user's cart in local storage
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
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart', style: GoogleFonts.lato()),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final item = cartItems[index];
          print(item);
          return Center(
            child: Container(
              width: width / 2, // Set the container width to half of the screen width
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Image.network(
                        "http://92.112.194.129:3000/" + (item['image'] ?? ''),
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['description'] ?? '',
                              style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text('Quantity: ${item['quantity'] ?? ''}', style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.w500)),
                            SizedBox(height: 8),
                            Text('Price: \$${item['price'] ?? ''}', style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () => _updateQuantity(index, 1),
                          ),
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () => _updateQuantity(index, -1),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _orderNow,
        label: Text(
          'Order Now',
          style: GoogleFonts.lato(fontWeight: FontWeight.bold),
        ),
        icon: Icon(Icons.shopping_cart),
        backgroundColor: Colors.blue,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
    );
  }
}

class MyOrdersScreen extends StatefulWidget {
  MyOrdersScreen({Key? key}) : super(key: key);

  @override
  _MyOrdersScreenState createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  List<Map<String, dynamic>> orders = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    String? userId = html.window.localStorage['userId'];
    if (userId == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final response = await http.post(Uri.parse('http://92.112.194.129:3000/get-orders-with-carts/$userId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        orders = List<Map<String, dynamic>>.from(data);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to load orders')));
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('My Orders', style: GoogleFonts.lato()),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Center(
                  child: Container(
                    width: width / 2, // Set the container width to half of the screen width
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                'Order ID: ${order['_id']}',
                                style: GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 8),
                            Center(
                              child: Text(
                                'Status: ${order['status']}',
                                style: GoogleFonts.lato(fontSize: 16, color: Colors.grey[600]),
                              ),
                            ),
                            SizedBox(height: 16),
                            ...order['carts'].map<Widget>((cart) {
                              final baloon = cart['baloonId'];
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Quantity: ${cart['quantity'] ?? ''}',
                                            style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Price: \$${baloon['price'] ?? ''}',
                                            style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Image.network(
                                          "http://92.112.194.129:3000/" + (baloon['image'] ?? ''),
                                          width: 70,
                                          height: 70,
                                          fit: BoxFit.cover,
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          baloon['name'] ?? '',
                                          style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
