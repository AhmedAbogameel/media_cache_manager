
---

# 📦 media\_cache\_manager

⚡ **Helps you to cache and encrypt media (Audio 🎵, Video 🎬, Image 🖼️, etc...) Permanently or for a specific time.**

With just a **URL**, the `DownloadMediaBuilder` widget will:

* 🔍 Search locally for the file.
* 📂 If found → File will be returned in a snapshot.
* ⬇️ If not found → File will be downloaded and stored locally, then returned in a snapshot.

---

## ✨ What’s New?

* 🗓️ **`daysToExpire`** behavior improved.
* ⚙️ **`autoDownload`** option to enable/disable auto download.
* 📝 Renamed **`onInit` ➝ `onInitialize`**.
* 🔄 Added **initial state** to `DownloadMediaStatus`.
* 🔐 Encrypt & decrypt files with **AES**.
* ⏹️ Cancel downloads anytime.
* 🔁 Retry failed downloads.
* 🔄 Added **Encrypting / Decrypting** states.
* 🧩 Refactored `DownloadMediaBuilder` widget.
* 🚀 Optimized plugin imports.

---

## 📥 Install

Add to your `pubspec.yaml`:

```yaml
dependencies:
  media_cache_manager: 
```

### ⚙️ Android Setup

1. Open **android → app → build.gradle**
2. Add this inside `defaultConfig`:

```gradle
multiDexEnabled true
minSdkVersion 20
```

---

## 🚀 Initializing Plugin (Required)

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MediaCacheManager.instance.init();
  runApp(const MyApp());
}
```

---

## 🔐 Encrypted Files (Optional)

Encrypt media files using **AES (OFB mode)**.

### ✅ Enable encryption globally

```dart
await MediaCacheManager.instance.setEncryptionPassword("I love flutter");
```

or directly on init:

```dart
await MediaCacheManager.instance.init(encryptionPassword: 'I love flutter');
```

⚠️ Notes:

* 🐢 Large files may take more time to en/decrypt.
* 🔒 Files are stored in **Temporary Directory**, so users & other apps can’t access them.
* 🔑 Keep passwords safe! The plugin **does not cache** your file passwords.

### 🔐 Encrypt single file

```dart
DownloadMediaBuilder(
  url: "https://example.com/sample.jpg",
  encryptionPassword: "this is a password",  
  onSuccess: (snapshot) {
    return Image.file(File(snapshot.filePath!));
  }
)
```

---

## ⏳ File Expiration (Optional)

Make cached files **expire automatically** after specific days.

```dart
await MediaCacheManager.instance.setExpireDate(daysToExpire: 10);
```

or via init:

```dart
await MediaCacheManager.instance.init(daysToExpire: 1);
```

📌 Behavior: If a file is accessed before its expiration → expiration will **extend** automatically.

---

## ⚡ General Usage

```dart
DownloadMediaBuilder(
  url: 'https://example.com/sample.jpg',
  onSuccess: (snapshot) {
    return Image.file(File(snapshot.filePath!));
  },
  onLoading: (snapshot) {
    return LinearProgressIndicator(value: snapshot.progress);
  },
),
```

---

## ⏯️ Disable Auto Download

By default, `autoDownload` = **true**.
You can disable it and control downloads manually:

```dart
late DownloadMediaBuilderController controller;

DownloadMediaBuilder(
  url: 'https://example.com/video.mp4',
  autoDownload: false,
  onInitialize: (ctrl) => controller = ctrl,
  onInitial: (_) {
    return ElevatedButton(
      onPressed: controller.getFile,
      child: const Text('Load file'),
    );
  },
  onSuccess: (snapshot) => BetterPlayer.file(snapshot.filePath!),
  onLoading: (snapshot) => LinearProgressIndicator(value: snapshot.progress),
),
```

---

## ⚠️ Handle Loading & Error States

```dart
DownloadMediaBuilder(
  url: 'https://example.com/video.mp4',
  onLoading: (snapshot) => LinearProgressIndicator(value: snapshot.progress),
  onSuccess: (snapshot) => BetterPlayer.file(snapshot.filePath!),
  onError: (_) => const Text('❌ Error!'),
),
```

---

## ⏹️ Cancel & 🔄 Retry Downloads

```dart
late DownloadMediaBuilderController controller;

DownloadMediaBuilder(
  url: 'https://example.com/video.mp4',
  onInitialize: (ctrl) => controller = ctrl,
  onLoading: (snapshot) {
    return Column(
      children: [
        LinearProgressIndicator(value: snapshot.progress),
        ElevatedButton(
          onPressed: controller.cancel,
          child: const Text('Cancel Download'),
        ),
      ],
    );
  },
  onSuccess: (snapshot) => BetterPlayer.file(snapshot.filePath!),
  onError: (_) => const Text('❌ Error!'),
  onCancel: (_) {
    return ElevatedButton(
      onPressed: controller.retry,
      child: const Text('Retry'),
    );
  },
),
```

📌 Notes:

* ❌ You can only call **cancel()** if status = `loading`.
* 🔁 You can only call **retry()** if status = `canceled`.

---

## 📊 Snapshot Explained

`DownloadMediaSnapshot` contains 3 fields:

1. **Status** → `Initial`, `Success`, `Loading`, `Error`, `Canceled`, `Encrypting`, `Decrypting`.
2. **FilePath** → Available if file is downloaded.
3. **Progress** → Download progress (0 → 1).

---