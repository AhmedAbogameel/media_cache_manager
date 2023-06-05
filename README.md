# media_cache_manager

#### helps you to cache media (Audio, Video, Image, etc...) Permanently or for specific time.

##### With a URL the [DownloadMediaBuilder] Widget search locally for the file, if file found get it back to snapshot object, if not found then download it then give it to snapshot.

## Install 
in pubspec.yaml file under dependencies add
```
media_cache_manager: 
```

### For Android :
Go to android -> app -> build.gradle
and add this line inside defaultConfig scope 
```
multiDexEnabled true
```
and modify minSdkVersion to 20

## SetExpireDate ( Optional )
before using the DownloadMediaBuilder Widget you have to call this method for once.
ex: I am calling it in main method or at my splash screen.
if you didn't call this method it will cache Permanently.
```
await DownloadCacheManager.setExpireDate(daysToExpire: 10);
```

## General Usage

```
import 'package:media_cache_manager/media_cache_manager.dart';
```

```
DownloadMediaBuilder(
  url: 'https://static.remove.bg/remove-bg-web/5c20d2ecc9ddb1b6c85540a333ec65e2c616dbbd/assets/start-1abfb4fe2980eabfbbaaa4365a0692539f7cd2725f324f904565a9a744f8e214.jpg',
  builder: (context, snapshot) {
    if (snapshot.status == DownloadMediaStatus.success) {
      return Image.file(File(snapshot.filePath!));
    }
    return null;
  },
),
```

## Handle Loading and error states

```
DownloadMediaBuilder(
  url: 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_30mb.mp4',
  builder: (context, snapshot) {
    if (snapshot.status == DownloadMediaStatus.loading) {
      return LinearProgressIndicator(value: snapshot.progress);
    }
    if (snapshot.status == DownloadMediaStatus.success) {
      return BetterPlayer.file(snapshot.filePath!);
    }
    return const Text('Error!');
  },
),
```

## Handle Canceled and retry states

```
late DownloadMediaBuilderController controller;

DownloadMediaBuilder(
  url: 'https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_30mb.mp4',
  onInit: (controller) => this.controller = controller,
  builder: (context, snapshot) {
    /// Retry to download the file if the status is canceled
    if (snapshot.status == DownloadMediaStatus.canceled) {
      return ElevatedButton(
         onPressed: controller.retry,
         child: const Text('Retry'),
       );
     }
     if (snapshot.status == DownloadMediaStatus.success) {
       return BetterPlayer.file(snapshot.filePath!);
     }
     /// Cancel download if the status is still loading
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
     return const Text('Error!');
   },
 ),
```
> Note: if the status is not loading you can not call cancelDownload function
> retry function is only available if the status is loading

## Explaining of snapshot
#### DownloadMediaSnapshot has three fields :
- ##### Status, it has 3 status (Success, Loading, Error, Canceled).
- ##### FilePath, it will be available if the file had been downloaded.
- ##### Progress, it's the process progress if the file is downloading.