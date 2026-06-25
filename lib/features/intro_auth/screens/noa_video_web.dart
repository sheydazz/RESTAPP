// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui;
import 'package:flutter/material.dart';

class NoaVideoWeb extends StatefulWidget {
  final double width;
  final double height;

  const NoaVideoWeb({super.key, required this.width, required this.height});

  @override
  State<NoaVideoWeb> createState() => _NoaVideoWebState();
}

class _NoaVideoWebState extends State<NoaVideoWeb> {
  late final String _viewId;
  late final html.VideoElement _videoElement;

  @override
  void initState() {
    super.initState();
    _viewId = 'noa-video-${DateTime.now().millisecondsSinceEpoch}';

    _videoElement = html.VideoElement()
      ..src = 'assets/assets/VideosAnimaciones/VideoWelcomeNoa1.mp4'
      ..autoplay = true
      ..loop = true
      ..muted = true
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.objectFit = 'contain'
      ..style.background = 'white'
      ..style.border = 'none'
      ..style.outline = 'none';

    ui.platformViewRegistry.registerViewFactory(
      _viewId,
      (int id) => _videoElement,
    );
  }

  @override
  void dispose() {
    _videoElement.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: HtmlElementView(viewType: _viewId),
    );
  }
}
