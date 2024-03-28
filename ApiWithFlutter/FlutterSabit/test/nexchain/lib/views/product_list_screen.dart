


import 'package:flutter/material.dart';
import 'package:nexchain/services/api_service.dart';

import '../models/product.dart';

class ProductListScreen extends StatefulWidget {
  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final products = await ApiService().getProducts();
      setState(() {
        _products = products;
      });
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return ListTile(
            title: Text(product.productName),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Price: \$${product.price.toStringAsFixed(2)}'),
                Text('Purchase Date: ${product.purchaseDate.toString()}'),
                Text('Quantity: ${product.quantity.toString()}'),
                Text('ID: ${product.id.toString()}'),
                // Add any other details you want to display
              ],
            ),
          );
        },
      ),
    );
  }
}