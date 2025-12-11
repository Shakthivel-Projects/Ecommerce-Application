import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/order_provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<OrderProvider>().loadMyOrders());
  }

  @override
  Widget build(BuildContext context) {
    final ordersProvider = context.watch<OrderProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: ordersProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: ordersProvider.orders.length,
              itemBuilder: (_, i) {
                final order = ordersProvider.orders[i];
                return ListTile(
                  title:
                      Text('₹${order.totalPrice.toStringAsFixed(2)}'),
                  subtitle: Text(order.shippingAddress.address),
                  trailing:
                      Text(order.isPaid ? 'Paid' : 'Pending'),
                );
              },
            ),
    );
  }
}
