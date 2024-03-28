

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


import '../models/product.dart';
import '../services/api_service.dart';

class ProductTableScreen extends StatefulWidget {
  @override
  _ProductTableScreenState createState() => _ProductTableScreenState();
}

class _ProductTableScreenState extends State<ProductTableScreen> {
  final ApiService _apiService = ApiService();
  List<Product> _products = [];

  final _formKey = GlobalKey<FormState>();
  // late Product _editedProduct;



  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final products = await _apiService.getProducts();
      setState(() {
        _products = products;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _updateProduct(Product product) async {
    try {
      await _apiService.updateProduct(product);
      _fetchProducts(); // Refresh the product list after update
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _deleteProduct(int id) async {
    try {
      await _apiService.deleteProduct(id);
      _fetchProducts(); // Refresh the product list after deletion
    } catch (e) {
      print(e.toString());
    }
  }


void _showUpdateDialog(Product product) {
    String? updatedProductName;
    double? updatedPrice;
    int? updatedQuantity;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Product'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: product.productName,
                  decoration: InputDecoration(labelText: 'Product Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a product name';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    updatedProductName = value;
                  },
                ),
                TextFormField(
                  initialValue: product.price.toString(),
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid price';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    updatedPrice = double.parse(value!);
                  },
                ),
                TextFormField(
                  initialValue: product.quantity.toString(),
                  decoration: InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a quantity';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid quantity';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    updatedQuantity = int.parse(value!);
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                final updatedProduct = Product(
                  id: product.id,
                  productName: updatedProductName ?? product.productName,
                  purchaseDate: product.purchaseDate,
                  price: updatedPrice ?? product.price,
                  quantity: updatedQuantity ?? product.quantity,
                );
                _updateProduct(updatedProduct);
                Navigator.of(context).pop();
              }
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Table'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 600) {
            // Use DataTable for larger screens
            return SingleChildScrollView(
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Product Name')),
                  DataColumn(label: Text('Purchase Date')),
                  DataColumn(label: Text('Price')),
                  DataColumn(label: Text('Quantity')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: _products
                    .map(
                      (product) => DataRow(
                        cells: [
                          DataCell(Text(product.productName)),
                          DataCell(
                            Text(
                              DateFormat.yMd().format(product.purchaseDate),
                            ),
                          ),
                          DataCell(Text('\$${product.price}')),
                          DataCell(Text('${product.quantity}')),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                  _showUpdateDialog(product);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    _deleteProduct(product.id);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            );
          } else {
            // Use ListView for smaller screens
            return ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final product = _products[index];
                return ListTile(
                  title: Text(product.productName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Purchase Date: ${DateFormat.yMd().format(product.purchaseDate)}',
                      ),
                      Text('Price: \$${product.price}'),
                      Text('Quantity: ${product.quantity}'),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _updateProduct(product);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteProduct(product.id);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}