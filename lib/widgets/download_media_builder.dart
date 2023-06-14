part of '../media_cache_manager.dart';

/// Usage: Getting File from cache if not cached yet,
/// it will be downloaded.
class DownloadMediaBuilder extends StatefulWidget {
  const DownloadMediaBuilder({
    Key? key,
    required this.url,
    this.onSuccess,
    this.onLoading,
    this.onError,
    this.onCancel,
    this.onEncrypting,
    this.onDecrypting,
    this.onInit,
  }) : super(key: key);

  /// URL of any type of media (Audio, Video, Image, etc...)
  final String url;

  /// Provides you a controller to make it easy for controlling [DownloadMediaBuilder]
  final void Function(DownloadMediaBuilderController controller)? onInit;

  /// Render widget when download status is success.
  final Widget Function(DownloadMediaSnapshot snapshot)? onSuccess;
  /// Render widget when download status is loading.
  final Widget Function(DownloadMediaSnapshot snapshot)? onLoading;
  /// Render widget when download status is error.
  final Widget Function(DownloadMediaSnapshot snapshot)? onError;
  /// Render widget when download status is cancel.
  final Widget Function(DownloadMediaSnapshot snapshot)? onCancel;
  /// Render widget when download status is encrypting.
  final Widget Function(DownloadMediaSnapshot snapshot)? onEncrypting;
  /// Render widget when download status is decrypting.
  final Widget Function(DownloadMediaSnapshot snapshot)? onDecrypting;

  @override
  State<DownloadMediaBuilder> createState() => _DownloadMediaBuilderState();
}

class _DownloadMediaBuilderState extends State<DownloadMediaBuilder> with WidgetsBindingObserver {
  late DownloadMediaBuilderController _downloadMediaBuilderController;
  late DownloadMediaSnapshot snapshot;

  late Map<DownloadMediaStatus, Widget Function(DownloadMediaSnapshot snapshot)?> statusRenderingWidgets;

  @override
  void initState() {
    statusRenderingWidgets = {
      DownloadMediaStatus.success: widget.onSuccess,
      DownloadMediaStatus.loading: widget.onLoading,
      DownloadMediaStatus.encrypting: widget.onEncrypting,
      DownloadMediaStatus.decrypting: widget.onDecrypting,
      DownloadMediaStatus.error: widget.onError,
      DownloadMediaStatus.canceled: widget.onCancel,
    };

    if (Encryptor.instance.isEnabled) {
      WidgetsBinding.instance.addObserver(this);
    }
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

    /// Getting cached file if not found it will be downloaded
    _downloadMediaBuilderController.getFile();

    if (widget.onInit != null) {
      /// Pass DownloadMediaBuilderController to onInit callback
      widget.onInit!(_downloadMediaBuilderController);
    }

    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _downloadMediaBuilderController.getFile();
    } else if (state == AppLifecycleState.detached || state == AppLifecycleState.paused) {
      deleteDecryptedFile();
    }
  }

  @override
  void dispose() {
    if (Encryptor.instance.isEnabled) {
      WidgetsBinding.instance.removeObserver(this);
      deleteDecryptedFile();
    }
    super.dispose();
  }

  void deleteDecryptedFile() async {
    if (snapshot.filePath != null) {
      await File(snapshot.filePath!).delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final callback = statusRenderingWidgets[snapshot.status];
    if (callback != null) {
      return callback(snapshot);
    }
    return const SizedBox.shrink();
  }
}
