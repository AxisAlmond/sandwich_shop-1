import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/views/cart_screen.dart';
import 'package:sandwich_shop/views/common_widgets.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/models/sandwich.dart';
import 'package:sandwich_shop/views/profile_screen.dart';
import 'package:sandwich_shop/views/settings_screen.dart';

class OrderScreen extends StatefulWidget {
  final int maxQuantity;

  const OrderScreen({super.key, this.maxQuantity = 10});

  @override
  State<OrderScreen> createState() {
    return _OrderScreenState();
  }
}

class _OrderScreenState extends State<OrderScreen> {
  final TextEditingController _notesController = TextEditingController();

  SandwichType _selectedSandwichType = SandwichType.veggieDelight;
  bool _isFootlong = true;
  BreadType _selectedBreadType = BreadType.white;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _navigateToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }

  Future<void> _navigateToProfile() async {
    final result = await Navigator.push<Map<String, String>>(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfileScreen(),
      ),
    );

    if (result != null && mounted) {
      _showWelcomeMessage(result);
    }
  }

  void _showWelcomeMessage(Map<String, String> profileData) {
    final name = profileData['name']!;
    final location = profileData['location']!;
    SnackBarHelper.showSuccess(
      context,
      'Welcome, $name! Ordering from $location',
    );
  }

  void _addToCart() {
    final sandwich = Sandwich(
      type: _selectedSandwichType,
      isFootlong: _isFootlong,
      breadType: _selectedBreadType,
    );

    final cart = Provider.of<Cart>(context, listen: false);
    cart.add(sandwich, quantity: _quantity);

    final String sizeText = _isFootlong ? 'Footlong' : 'Six-inch';
    SnackBarHelper.showSuccess(
      context,
      'Added $_quantity ${sandwich.name} $sizeText sandwich(es) on ${_selectedBreadType.name} bread to cart',
    );
  }

  VoidCallback? _getAddToCartCallback() {
    if (_quantity > 0) {
      return _addToCart;
    } else {
      return null;
    }
  }

  void _navigateToCartView() {
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) => const CartScreen(),
      ),
    );
  }

  List<DropdownMenuEntry<SandwichType>> _buildSandwichTypeEntries() {
    return SandwichType.values.map((type) {
      String displayName = '';
      switch (type) {
        case SandwichType.veggieDelight:
          displayName = 'Veggie Delight';
          break;
        case SandwichType.chickenTeriyaki:
          displayName = 'Chicken Teriyaki';
          break;
        case SandwichType.tunaMelt:
          displayName = 'Tuna Melt';
          break;
        case SandwichType.meatballMarinara:
          displayName = 'Meatball Marinara';
          break;
      }
      return DropdownMenuEntry(value: type, label: displayName);
    }).toList();
  }

  List<DropdownMenuEntry<BreadType>> _buildBreadTypeEntries() {
    return BreadType.values.map((type) {
      String displayName = '';
      switch (type) {
        case BreadType.white:
          displayName = 'White';
          break;
        case BreadType.wheat:
          displayName = 'Wheat';
          break;
        case BreadType.wholemeal:
          displayName = 'Wholemeal';
          break;
      }
      return DropdownMenuEntry(value: type, label: displayName);
    }).toList();
  }

  String _getCurrentImagePath() {
    String typeString = _selectedSandwichType.name;
    String sizeString = _isFootlong ? 'footlong' : 'six_inch';
    return 'assets/images/${typeString}_$sizeString.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'Sandwich Counter'),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 300,
                child: Image.asset(
                  _getCurrentImagePath(),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Text('Image not found', style: normalText),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: DropdownMenu<SandwichType>(
                  initialSelection: _selectedSandwichType,
                  label: const Text('Select Sandwich Type'),
                  dropdownMenuEntries: _buildSandwichTypeEntries(),
                  onSelected: (SandwichType? value) {
                    if (value != null) {
                      setState(() {
                        _selectedSandwichType = value;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SwitchListTile(
                  title: Text(
                    _isFootlong ? 'Footlong' : 'Six Inch',
                    style: normalText,
                  ),
                  value: _isFootlong,
                  onChanged: (bool value) {
                    setState(() {
                      _isFootlong = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: DropdownMenu<BreadType>(
                  initialSelection: _selectedBreadType,
                  label: const Text('Select Bread Type'),
                  dropdownMenuEntries: _buildBreadTypeEntries(),
                  onSelected: (BreadType? value) {
                    if (value != null) {
                      setState(() {
                        _selectedBreadType = value;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Quantity: ', style: normalText),
                  IconButton(
                    onPressed: () {
                      if (_quantity > 0) {
                        setState(() {
                          _quantity--;
                        });
                      }
                    },
                    icon: const Icon(Icons.remove),
                  ),
                  Text('$_quantity', style: heading2),
                  IconButton(
                    onPressed: () {
                      if (_quantity < widget.maxQuantity) {
                        setState(() {
                          _quantity++;
                        });
                      }
                    },
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: StyledButton(
                  onPressed: _getAddToCartCallback(),
                  icon: Icons.add_shopping_cart,
                  label: 'Add to Cart',
                  backgroundColor: Colors.green,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: StyledButton(
                  onPressed: _navigateToCartView,
                  icon: Icons.shopping_cart,
                  label: 'View Cart',
                  backgroundColor: Colors.blue,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: StyledButton(
                  onPressed: _navigateToProfile,
                  icon: Icons.person,
                  label: 'Profile',
                  backgroundColor: Colors.purple,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: StyledButton(
                  onPressed: _navigateToSettings,
                  icon: Icons.settings,
                  label: 'Settings',
                  backgroundColor: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              Consumer<Cart>(
                builder: (context, cart, child) {
                  return Text(
                    'Cart: ${cart.countOfItems} items - £${cart.totalPrice.toStringAsFixed(2)}',
                    style: normalText,
                    textAlign: TextAlign.center,
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}