import 'dart:developer';
import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:media_cache_manager/media_cache_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MediaCacheManager.instance.init(
    encryptionPassword: 'i love flutter'
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
              url: 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_30mb.mp4',
              onInit: (controller) => this.controller = controller,
              builder: (context, snapshot) {
                if (snapshot.status == DownloadMediaStatus.decrypting) {
                  return const Center(
                    child: Text('File is under decryption...'),
                  );
                }
                if (snapshot.status == DownloadMediaStatus.encrypting) {
                  return const Center(
                    child: Text('File is under encryption...'),
                  );
                }
                if (snapshot.status == DownloadMediaStatus.loading) {
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
                }
                if (snapshot.status == DownloadMediaStatus.canceled) {
                  return ElevatedButton(
                    onPressed: controller.retry,
                    child: const Text('Retry'),
                  );
                }
                if (snapshot.status == DownloadMediaStatus.success) {
                  return BetterPlayer.file(snapshot.filePath!);
                }
                return const Text('Error!');
              },
            ),
          ],
        ),
      ),
    );
  }
}
