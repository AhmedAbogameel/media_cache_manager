import 'package:flutter/material.dart';
import '../media_cache_manager.dart';

/// Usage: Getting File from cache if not cached yet,
/// it will be downloaded.
class DownloadMediaBuilder extends StatefulWidget {
  const DownloadMediaBuilder({
    Key? key,
    required this.url,
    required this.builder,
    this.onInit,
  }) : super(key: key);

  /// URL of any type of media (Audio, Video, Image, etc...)
  final String url;

  /// Provides you a controller to make it easy for controlling [DownloadMediaBuilder]
  final void Function(DownloadMediaBuilderController controller)? onInit;

  /// Snapshot Will provide you the status of process
  /// (Success, Error, Loading, Canceled)
  /// and file if downloaded and download progress
  final Widget? Function(BuildContext context, DownloadMediaSnapshot snapshot) builder;

  @override
  State<DownloadMediaBuilder> createState() => _DownloadMediaBuilderState();
}

class _DownloadMediaBuilderState extends State<DownloadMediaBuilder> {

  late DownloadMediaBuilderController _downloadMediaBuilderController;
  late DownloadMediaSnapshot snapshot;

  @override
  void initState() {
    /// Initialize widget DownloadMediaSnapshot
    snapshot = DownloadMediaSnapshot(
      status: DownloadMediaStatus.loading,
      filePath: null,
      progress: null,
    );

    /// Initializing Widget Controller
    _downloadMediaBuilderController = DownloadMediaBuilderController(
      url: widget.url,
      snapshot: snapshot,
      onSnapshotChanged: (snapshot) {
        if (mounted) {
          setState(() => this.snapshot = snapshot);
        }
      },
    );

    /// Initializing Caching Database and get cached File
    DownloadCacheManager.init().then((value) {
      /// Getting cached file if not found it will be downloaded
      _downloadMediaBuilderController.getFile();
    });

    if (widget.onInit != null) {
      /// Pass DownloadMediaBuilderController to onInit callback
      widget.onInit!(_downloadMediaBuilderController);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      snapshot,
    ) ?? const SizedBox.shrink();
  }
}