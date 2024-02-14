import 'package:flutter/material.dart';

import 'cached_network_image.dart';

class FullScreenImagePage extends StatelessWidget {
  const FullScreenImagePage({super.key, required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(color: Colors.black),
          ),
          Center(
            child: InteractiveViewer(
              minScale: 1,
              maxScale: 3,
              clipBehavior: Clip.none,
              child: CachedNetworkImageCustom(url: url, radius: 0),
            ),
          ),
        ],
      ),
    );
  }
}
