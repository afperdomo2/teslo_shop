import 'package:flutter/material.dart';

class ProductsScreen extends StatelessWidget {
  static const String routeName = 'products';

  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: Center(child: Text('Welcome to the Products Screen!')),
    );
  }
}
