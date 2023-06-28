import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:media_cache_manager/media_cache_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MediaCacheManager.instance.init(
    encryptionPassword: 'i love flutter',
    daysToExpire: 1,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

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
              url: 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4',
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
                return BetterPlayer.file(snapshot.filePath!);
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
