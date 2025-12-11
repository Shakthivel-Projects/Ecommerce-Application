import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: cart.items.values.map((item) {
                return ListTile(
                  leading: Image.network(item.product.image, width: 50),
                  title: Text(item.product.title),
                  subtitle: Text(
                      '₹${item.product.price} x ${item.quantity} = ₹${item.totalPrice.toStringAsFixed(2)}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      cart.removeFromCart(item.product.id);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total'),
                    Text('₹${cart.totalAmount.toStringAsFixed(2)}'),
                  ],
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: cart.items.isEmpty
                      ? null
                      : () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const CheckoutScreen()),
                          );
                        },
                  child: const Text('Proceed to checkout'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
