import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/views/common_widgets.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/repositories/pricing_repository.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  bool _isProcessing = false;

  Future<void> _processPayment() async {
    setState(() {
      _isProcessing = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    final DateTime currentTime = DateTime.now();
    final int timestamp = currentTime.millisecondsSinceEpoch;
    final String orderId = 'ORD$timestamp';

    // ignore: use_build_context_synchronously
    final Cart cart = Provider.of<Cart>(context, listen: false);
    final Map orderConfirmation = {
      'orderId': orderId,
      'totalAmount': cart.totalPrice,
      'itemCount': cart.countOfItems,
      'estimatedTime': '15-20 minutes',
    };

    if (mounted) {
      Navigator.pop(context, orderConfirmation);
    }
  }

  double _calculateItemPrice(Sandwich sandwich, int quantity) {
    PricingRepository repo = PricingRepository();
    return repo.calculatePrice(
        quantity: quantity, isFootlong: sandwich.isFootlong);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(
        title: 'Checkout',
        showCartCounter: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Consumer<Cart>(
          builder: (context, cart, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Order Summary', style: heading2),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final sandwich = cart.items.keys.elementAt(index);
                      final quantity = cart.items[sandwich]!;
                      final itemPrice = _calculateItemPrice(sandwich, quantity);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${quantity}x ${sandwich.name}',
                                style: normalText),
                            Text('£${itemPrice.toStringAsFixed(2)}',
                                style: normalText),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total:', style: heading2),
                    Text('£${cart.totalPrice.toStringAsFixed(2)}',
                        style: heading2),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  'Payment Method: Card ending in 1234',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                if (_isProcessing)
                  const Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 10),
                      Text('Processing payment...'),
                    ],
                  )
                else
                  ElevatedButton(
                    onPressed: _processPayment,
                    child: const Text('Confirm Payment'),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}