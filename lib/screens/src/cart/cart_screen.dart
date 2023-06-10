import 'package:cashor_app/components/single_scaffold.dart';
import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleScaffold(
      title: "Cart",
      child: SingleChildScrollView(
        child: Container(),
      ),
    );
  }
}
