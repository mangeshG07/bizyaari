import 'package:businessbuddy/utils/exported_path.dart';

class VideoTimeline extends StatelessWidget {
  final VideoPlayerControllerX controller;

  const VideoTimeline({super.key, required this.controller});

  String _format(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final videoCtrl = controller.videoController;
    if (videoCtrl == null) return const SizedBox.shrink();

    return Positioned(
      left: 8,
      right: 8,
      bottom: 100,
      child: ValueListenableBuilder<VideoPlayerValue>(
        valueListenable: videoCtrl,
        builder: (context, value, _) {
          final duration = value.duration;
          final position = value.position;

          if (duration == Duration.zero) {
            return const SizedBox.shrink();
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// ⏱ Time Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _format(position),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    _format(duration),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 2),

              /// 🎚 Timeline Slider
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 2,
                  thumbShape:
                  const RoundSliderThumbShape(enabledThumbRadius: 6),
                  overlayShape: SliderComponentShape.noOverlay,
                  activeTrackColor: Colors.white,
                  inactiveTrackColor: Colors.white30,
                  thumbColor: Colors.white,
                ),
                child: Slider(
                  min: 0,
                  max: duration.inMilliseconds.toDouble(),
                  value: position.inMilliseconds
                      .clamp(0, duration.inMilliseconds)
                      .toDouble(),
                  onChanged: (value) {
                    videoCtrl.seekTo(
                      Duration(milliseconds: value.toInt()),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

