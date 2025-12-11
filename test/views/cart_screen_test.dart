import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/views/cart_screen.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';

void main() {
  group('CartScreen', () {
    testWidgets('displays empty cart message when cart is empty',
        (WidgetTester tester) async {
      final Cart emptyCart = Cart();
      await tester.pumpWidget(
        ChangeNotifierProvider<Cart>.value(
          value: emptyCart,
          child: const MaterialApp(home: CartScreen()),
        ),
      );

      expect(find.text('Your Cart'), findsOneWidget);
      expect(find.text('Your cart is empty.'), findsOneWidget);
      expect(find.text('Total: £0.00'), findsOneWidget);
    });

    testWidgets('displays cart items when cart has items',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 2);

      await tester.pumpWidget(
        ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: const MaterialApp(home: CartScreen()),
        ),
      );

      expect(find.text('Veggie Delight'), findsOneWidget);
      expect(find.text('Footlong on white bread'), findsOneWidget);
      expect(find.text('Qty: 2'), findsOneWidget);
    });

    testWidgets('displays multiple cart items correctly',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich1 = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      final Sandwich sandwich2 = Sandwich(
        type: SandwichType.chickenTeriyaki,
        isFootlong: false,
        breadType: BreadType.wheat,
      );
      cart.add(sandwich1, quantity: 1);
      cart.add(sandwich2, quantity: 3);

      await tester.pumpWidget(
        ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: const MaterialApp(home: CartScreen()),
        ),
      );

      expect(find.text('Veggie Delight'), findsOneWidget);
      expect(find.text('Chicken Teriyaki'), findsOneWidget);
      expect(find.text('Footlong on white bread'), findsOneWidget);
      expect(find.text('Six-inch on wheat bread'), findsOneWidget);
      expect(find.text('Qty: 1'), findsOneWidget);
      expect(find.text('Qty: 3'), findsOneWidget);
    });

    testWidgets('shows checkout button when cart has items',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 1);

      await tester.pumpWidget(
        ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: const MaterialApp(home: CartScreen()),
        ),
      );

      expect(find.widgetWithText(ElevatedButton, 'Checkout'), findsOneWidget);
    });

    testWidgets('hides checkout button when cart is empty',
        (WidgetTester tester) async {
      final Cart emptyCart = Cart();
      await tester.pumpWidget(
        ChangeNotifierProvider<Cart>.value(
          value: emptyCart,
          child: const MaterialApp(home: CartScreen()),
        ),
      );

      expect(find.widgetWithText(ElevatedButton, 'Checkout'), findsNothing);
    });

    testWidgets('increment quantity button works correctly',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 1);

      await tester.pumpWidget(
        ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: const MaterialApp(home: CartScreen()),
        ),
      );

      expect(find.text('Qty: 1'), findsOneWidget);

      final Finder addButtonFinder = find.byIcon(Icons.add).first;
      await tester.tap(addButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text('Qty: 2'), findsOneWidget);
    });

    testWidgets('decrement quantity button works correctly',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 2);

      await tester.pumpWidget(
        ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: const MaterialApp(home: CartScreen()),
        ),
      );

      expect(find.text('Qty: 2'), findsOneWidget);

      final Finder removeButtonFinder = find.byIcon(Icons.remove).first;
      await tester.tap(removeButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text('Qty: 1'), findsOneWidget);
    });

    testWidgets('remove item button works correctly',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      final Sandwich sandwich = Sandwich(
        type: SandwichType.veggieDelight,
        isFootlong: true,
        breadType: BreadType.white,
      );
      cart.add(sandwich, quantity: 2);

      await tester.pumpWidget(
        ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: const MaterialApp(home: CartScreen()),
        ),
      );

      expect(find.text('Veggie Delight'), findsOneWidget);

      final Finder deleteButtonFinder = find.byIcon(Icons.delete).first;
      await tester.tap(deleteButtonFinder);
      await tester.pumpAndSettle();

      expect(find.text('Veggie Delight'), findsNothing);
      expect(find.text('Your cart is empty.'), findsOneWidget);
    });

    testWidgets('back button is present and functional',
        (WidgetTester tester) async {
      final Cart cart = Cart();
      await tester.pumpWidget(
        ChangeNotifierProvider<Cart>.value(
          value: cart,
          child: const MaterialApp(home: CartScreen()),
        ),
      );

      await tester.pumpAndSettle();

      final Finder backButtonFinder =
          find.widgetWithText(ElevatedButton, 'Back to Order');
      expect(backButtonFinder, findsOneWidget);
    });
  });
}
