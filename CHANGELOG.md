## 0.3.0
* upgrade dependencies.
* upgrade example dependencies.
* fix removing cached file from device throwing PathNotFoundException error (https://github.com/AhmedAbogameel/media_cache_manager/issues/7)
* fix bug while changing onLoading, onSuccess callbacks etc.. after DownloadMediaBuilder has been in widget tree it's not affected else if you run hot restart 

## 0.2.2
* daysToExpire behavior changed.

## 0.2.1
* autoDownload option to enable/disable auto download.
* Rename onInit callback to onInitialize.
* Add initial state to DownloadMediaStatus.
* Bugs fixed.

## 0.2.0
* Encrypt and decrypt downloaded files with AES.
* Encrypt Single File.
* Add Encrypting/Decrypting status.
* Optimize plugin imports.
* Refactor DownloadMediaBuilder Widget.

## 0.1.0
* Add Cancel/Retry for downloading.
* add onInit callback function to that gives you an instance of DownloadMediaBuilderController.
* DownloadMediaBuilderController to control DownloadMediaBuilder widget.
* Change some functions names.
* Downloader class changed.

## 0.0.2+2

* Upgrade dependencies.

## 0.0.2+1

* Some bugs fixed.

## 0.0.2

* ExpireDate (Optional) for cached media.

## 0.0.1

* First Version.