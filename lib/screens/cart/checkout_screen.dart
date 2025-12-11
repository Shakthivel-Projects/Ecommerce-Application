import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../../services/payment_api.dart';
import '../../services/order_api.dart';
import 'order_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  String fullName = '';
  String address = '';
  String city = '';
  String postalCode = '';
  String country = 'India';
  bool isPaying = false;

  Future<void> _handlePay(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final auth = context.read<AuthProvider>();
    if (!auth.isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please login to continue')),
      );
      return;
    }

    final cart = context.read<CartProvider>();
    final totalAmount = cart.totalAmount;
    final amountPaise = (totalAmount * 100).round();

    setState(() => isPaying = true);

    try {
      final paymentApi = PaymentApi();
      final items = cart.toOrderItemsJson();

      // 1) Backend: create PaymentIntent (server calculates real amount)
      final clientSecret = await paymentApi.createPaymentIntent(
        amountInPaise: amountPaise,
        items: items,
      );

      // 2) Init sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'My Shop',
        ),
      );

      // 3) Present payment UI
      await Stripe.instance.presentPaymentSheet();

      // 4) Payment succeeded → create order in backend
      final orderApi = OrderApi();
      final order = await orderApi.createOrder({
        'orderItems': items,
        'shippingAddress': {
          'fullName': fullName,
          'address': address,
          'city': city,
          'postalCode': postalCode,
          'country': country,
        },
        'itemsPrice': totalAmount,
        'taxPrice': 0,
        'shippingPrice': 0,
        'totalPrice': totalAmount,
        // You may store clientSecret or paymentIntentId separately
        'paymentIntentId': clientSecret.split('_secret').first,
      });

      cart.clear();

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OrderSuccessScreen(orderId: order.id),
        ),
      );
    } on StripeException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Payment cancelled: ${e.error.localizedMessage}'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: $e')),
      );
    } finally {
      if (mounted) setState(() => isPaying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              'Total: ₹${cart.totalAmount.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Full name'),
                    onSaved: (v) => fullName = v ?? '',
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null,
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Address'),
                    onSaved: (v) => address = v ?? '',
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null,
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'City'),
                    onSaved: (v) => city = v ?? '',
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                        labelText: 'Postal code'),
                    onSaved: (v) => postalCode = v ?? '',
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isPaying
                          ? null
                          : () => _handlePay(context),
                      child: isPaying
                          ? const CircularProgressIndicator()
                          : const Text('Pay with card'),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
