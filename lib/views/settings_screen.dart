import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
import 'package:sandwich_shop/views/common_widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double _fontSize = 16.0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    await AppStyles.loadFontSize();
    setState(() {
      _fontSize = AppStyles.baseFontSize;
      _isLoading = false;
    });
  }

  Future<void> _saveFontSize(double fontSize) async {
    await AppStyles.saveFontSize(fontSize);
    setState(() {
      _fontSize = fontSize;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: const CommonAppBar(
        title: 'Settings',
        showCartCounter: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Font Size', style: AppStyles.heading2),
            const SizedBox(height: 20),
            Text(
              'This is sample text to preview the font size.',
              style: TextStyle(fontSize: _fontSize),
            ),
            const SizedBox(height: 20),
            Slider(
              value: _fontSize,
              min: 12.0,
              max: 24.0,
              divisions: 24,
              label: _fontSize.toStringAsFixed(0),
              onChanged: _saveFontSize,
            ),
            Text(
              'Current size: ${_fontSize.toStringAsFixed(0)}',
              style: AppStyles.normalText,
            ),
            const SizedBox(height: 20),
            const Text(
              'Note: Restart the app to see changes applied everywhere.',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Back to Order'),
            ),
          ],
        ),
      ),
    );
  }
}