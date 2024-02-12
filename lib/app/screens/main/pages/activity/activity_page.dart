import 'package:flutter/material.dart';

import '../../../../../core/extensions/build_context.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: context.backgroundColor,
      ),
    );
  }
}
