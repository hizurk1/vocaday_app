import 'package:flutter/material.dart';

class BackButton extends StatelessWidget {
  const BackButton({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: const Icon(Icons.arrow_back),
    );
  }
}
