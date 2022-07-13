# media_cache_manager

#### This package helps you to cache media (Audio, Video, Image, etc...).

##### With a URL the [DownloadMediaBuilder] Widget search locally for the file, if file found get it back to snapshot object, if not found then download it then give it to snapshot.

## Install 
in pubspec.yaml file under dependencies add
```
media_cache_manager: 
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

## Explaining of snapshot
#### DownloadMediaSnapshot has three fields :
- ##### Status, it has 3 status (Success, Loading, Error).
- ##### FilePath, it will be available if the file had been downloaded.
- ##### Progress, it's the process progress if the file is downloading.