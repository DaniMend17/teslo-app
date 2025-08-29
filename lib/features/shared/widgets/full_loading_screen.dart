import 'package:flutter/material.dart';

class FullLoadingScreen extends StatelessWidget {
  const FullLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand(
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
