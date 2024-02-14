import 'package:flutter/material.dart';

import '../../core/extensions/build_context.dart';
import 'cached_network_image.dart';
import 'interactive_view_custom.dart';

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
            child: Container(
              color: Colors.black,
              width: context.screenWidth,
              height: context.screenHeight,
            ),
          ),
          Center(
            child: InteractiveViewerCustom(
              child: CachedNetworkImageCustom(
                url: url,
                radius: 0,
                allowOpenFullscreenImage: false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
