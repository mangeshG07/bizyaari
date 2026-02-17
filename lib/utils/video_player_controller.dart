import 'package:businessbuddy/utils/exported_path.dart';

@lazySingleton
class VideoPlayerControllerX extends GetxController {
  final String url;
  VideoPlayerControllerX(this.url);
  late bool isYouTube;

  VideoPlayerController? videoController;
  ChewieController? chewieController;
  YoutubePlayerController? youtubeController;
  final globalMute = getIt<GlobalVideoMuteController>();
  final isInitialized = false.obs;
  final isPlaying = false.obs;
  final aspectR = (9 / 16).obs;
  late Worker _muteWorker;

  @override
  void onInit() {
    super.onInit();
    isYouTube = url.contains('youtube.com') || url.contains('youtu.be');
    _initialize();

    /// 🔥 GLOBAL MUTE LISTENER
    _muteWorker = ever(globalMute.isMuted, (bool muted) {
      if (isClosed) return;

      if (isYouTube) {
        muted ? youtubeController?.mute() : youtubeController?.unMute();
      } else {
        if (videoController != null && videoController!.value.isInitialized) {
          videoController!.setVolume(muted ? 0 : 1);
        }
      }
    });
    // ever(globalMute.isMuted, (bool muted) {
    //   if (isYouTube) {
    //     muted ? youtubeController?.mute() : youtubeController?.unMute();
    //   } else {
    //     if (videoController != null && videoController!.value.isInitialized) {
    //       videoController!.setVolume(muted ? 0 : 1);
    //     }
    //   }
    // });
  }

  Future<void> _initialize() async {
    if (isYouTube) {
      youtubeController = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(url)!,
        flags: YoutubePlayerFlags(
          autoPlay: false,
          mute: globalMute.isMuted.value,
          loop: true,
        ),
      );

      isInitialized.value = true;
    } else {
      videoController = VideoPlayerController.networkUrl(Uri.parse(url));
      await videoController!.initialize();

      // ✅ ORIGINAL ASPECT RATIO
      aspectR.value = videoController!.value.aspectRatio;

      chewieController = ChewieController(
        videoPlayerController: videoController!,
        autoPlay: false,
        looping: true,
        showControls: false,
        // allowFullScreen: false,
      );

      videoController!.setVolume(globalMute.isMuted.value ? 0 : 1);

      isInitialized.value = true;
      isPlaying.value = true;
    }
  }

  void togglePlayPause() {
    if (isYouTube) return;

    if (videoController!.value.isPlaying) {
      videoController!.pause();
      isPlaying.value = false;
    } else {
      videoController!.play();
      isPlaying.value = true;
    }
  }

  void pause() {
    if (isYouTube) {
      youtubeController?.pause();
    } else {
      videoController?.pause();
    }
    isPlaying.value = false;
  }

  void play() {
    if (isYouTube) {
      youtubeController?.play();
    } else {
      videoController?.play();
    }
    isPlaying.value = true;
  }

  /// 🔊 Toggle mute / unmute
  void toggleMute() {
    globalMute.toggleMute();

    if (isYouTube) {
      if (globalMute.isMuted.value) {
        youtubeController?.mute();
      } else {
        youtubeController?.unMute();
      }
    } else {
      chewieController?.videoPlayerController.setVolume(
        globalMute.isMuted.value ? 0 : 1,
      );
    }
  }

  @override
  void onClose() {
    _muteWorker.dispose(); // 🔥 MOST IMPORTANT LINE
    chewieController?.pause();
    videoController?.pause();

    chewieController?.dispose();
    videoController?.dispose();
    youtubeController?.dispose();

    super.onClose();
  }
}
