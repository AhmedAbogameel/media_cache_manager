part of '../media_cache_manager.dart';

/// Usage: Getting File from cache if not cached yet,
/// it will be downloaded.
class DownloadMediaBuilder extends StatefulWidget {
  const DownloadMediaBuilder({
    Key? key,
    required this.url,
    this.onInitialize,
    this.onSuccess,
    this.onLoading,
    this.onError,
    this.onCancel,
    this.onEncrypting,
    this.onDecrypting,
    this.encryptionPassword,
    this.autoDownload = true,
    this.onInitial,
  }) : super(key: key);

  /// URL of any type of media (Audio, Video, Image, etc...)
  final String url;

  /// Encryption password is optional if not set
  /// the default password you have set using setEncryptionPassword method will be
  /// By assigning this variable you can encrypt files with different passwords.
  final String? encryptionPassword;

  /// If enabled download will start if widget has bounded to UI Tree
  /// Otherwise you should call method getFile from DownloadMediaBuilderController instance came from onInitialize callback
  final bool autoDownload;

  /// Provides you a controller to make it easy for controlling [DownloadMediaBuilder]
  final void Function(DownloadMediaBuilderController controller)? onInitialize;

  /// Render widget when download status is initial.
  final Widget Function(DownloadMediaSnapshot snapshot)? onInitial;

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

class _DownloadMediaBuilderState extends State<DownloadMediaBuilder>
    with WidgetsBindingObserver {
  late DownloadMediaBuilderController _downloadMediaBuilderController;
  late DownloadMediaSnapshot snapshot;

  late Map<DownloadMediaStatus,
      Widget Function(DownloadMediaSnapshot snapshot)?> statusRenderingWidgets;

  @override
  void initState() {
    statusRenderingWidgets = {
      DownloadMediaStatus.initial: widget.onInitial,
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
      status: DownloadMediaStatus.initial,
      filePath: null,
      progress: null,
    );

    /// Initializing Widget Controller
    _downloadMediaBuilderController = DownloadMediaBuilderController(
      url: widget.url,
      snapshot: snapshot,
      encryptionPassword: widget.encryptionPassword,
      onSnapshotChanged: (snapshot) {
        if (mounted) {
          setState(() => this.snapshot = snapshot);
        }
      },
    );

    if (widget.autoDownload) {
      /// Getting cached file if not found it will be downloaded
      _downloadMediaBuilderController.getFile();
    }

    if (widget.onInitialize != null) {
      /// Pass DownloadMediaBuilderController to onInitialize callback
      widget.onInitialize!(_downloadMediaBuilderController);
    }

    super.initState();
  }

  @override
  void didUpdateWidget(covariant DownloadMediaBuilder oldWidget) {
    statusRenderingWidgets = {
      DownloadMediaStatus.initial: widget.onInitial,
      DownloadMediaStatus.success: widget.onSuccess,
      DownloadMediaStatus.loading: widget.onLoading,
      DownloadMediaStatus.encrypting: widget.onEncrypting,
      DownloadMediaStatus.decrypting: widget.onDecrypting,
      DownloadMediaStatus.error: widget.onError,
      DownloadMediaStatus.canceled: widget.onCancel,
    };
    super.didUpdateWidget(oldWidget);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _downloadMediaBuilderController.getFile();
    } else if (state == AppLifecycleState.detached ||
        state == AppLifecycleState.paused) {
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
