import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/views/app_styles.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showCartCounter;
  final List<Widget>? additionalActions;

  const CommonAppBar({
    super.key,
    required this.title,
    this.showCartCounter = true,
    this.additionalActions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const AppBarLogo(),
      title: Text(title, style: heading1),
      actions: [
        if (additionalActions != null) ...additionalActions!,
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

/// Logo widget for AppBar
class AppBarLogo extends StatelessWidget {
  const AppBarLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: 100,
        child: Image.asset('assets/images/logo.png'),
      ),
    );
  }
}