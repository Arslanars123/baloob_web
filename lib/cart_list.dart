import 'package:flutter/material.dart';

class Product {
  final String name;
  final String imageUrl;
  final double price;
  final String size;

  Product({
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.size,
  });
}

List<Product> products = [
  Product(
    name: 'Product 1',
    imageUrl: 'https://example.com/image1.jpg',
    price: 29.99,
    size: 'M',
  ),
  Product(
    name: 'Product 2',
    imageUrl: 'https://example.com/image2.jpg',
    price: 49.99,
    size: 'L',
  ),
  // Add more products as needed
];

class CartList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
print(screenWidth);
          // Determine the container width based on screen width
          var containerWidth = screenWidth < 500 ? 300 : 400;
    var check = containerWidth.toDouble();
          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Center(
                child: Container(
                  width: check,
                  margin: EdgeInsets.symmetric(
                    vertical: 8.0,
                  ),
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: Row(
                    children: [
                      Image.network(
                        product.imageUrl,
                        width: 100.0,
                        height: 100.0,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              'Size: ${product.size}',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 4.0),
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
