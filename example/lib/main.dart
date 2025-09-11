import 'dart:io';

import 'package:flutter/material.dart';
import 'package:media_cache_manager/media_cache_manager.dart';
import 'package:video_player/video_player.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MediaCacheManager.instance.init(
    encryptionPassword: 'i love flutter',
    daysToExpire: 1,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late DownloadMediaBuilderController controller;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DownloadMediaBuilder(
              url:
                  'https://videos.pexels.com/video-files/4114797/4114797-uhd_2560_1440_25fps.mp4',
              encryptionPassword: "this is another password",
              autoDownload: false,
              onInitialize: (controller) => this.controller = controller,
              onInitial: (snapshot) {
                return ElevatedButton(
                  onPressed: controller.getFile,
                  child: const Text("Load file"),
                );
              },
              onSuccess: (snapshot) {
                return _FileVideoPlayer(filePath: snapshot.filePath!);
              },
              onLoading: (snapshot) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    LinearProgressIndicator(
                      value: snapshot.progress,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: controller.cancelDownload,
                      child: const Text('Cancel Download'),
                    ),
                  ],
                );
              },
              onCancel: (snapshot) {
                return ElevatedButton(
                  onPressed: controller.retry,
                  child: const Text('Retry'),
                );
              },
              onDecrypting: (snapshot) {
                return const Center(
                  child: Text('File is under decryption...'),
                );
              },
              onEncrypting: (snapshot) {
                return const Center(
                  child: Text('File is under encryption...'),
                );
              },
              onError: (snapshot) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(child: Text('Error Occurred!')),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: controller.retry,
                      child: const Text('Retry'),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _FileVideoPlayer extends StatefulWidget {
  const _FileVideoPlayer({
    required this.filePath,
  });

  final String filePath;

  @override
  State<_FileVideoPlayer> createState() => _FileVideoPlayerState();
}

class _FileVideoPlayerState extends State<_FileVideoPlayer> {
  late final VideoPlayerController controller;

  @override
  void initState() {
    controller = VideoPlayerController.file(File(widget.filePath))
      ..initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: VideoPlayer(controller),
    );
  }
}
