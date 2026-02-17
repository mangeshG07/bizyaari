import 'dart:io';

import 'package:businessbuddy/utils/exported_path.dart';

class VideoPreview extends StatefulWidget {
  final File file;
  const VideoPreview({super.key, required this.file});

  @override
  State<VideoPreview> createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(widget.file)
      ..initialize().then((_) {
        if (mounted) setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      _controller.value.isPlaying ? _controller.pause() : _controller.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return Center(child: LoadingWidget(color: primaryColor));
    }

    return GestureDetector(
      onTap: _togglePlayPause,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),

          /// Play / Pause button
          AnimatedOpacity(
            opacity: _controller.value.isPlaying ? 0 : 1,
            duration: const Duration(milliseconds: 200),
            child: CircleAvatar(
              radius: 28,
              backgroundColor: Colors.black.withValues(alpha: 0.5),
              child: Icon(
                _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                size: 40,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
