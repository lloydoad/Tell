# Tell
An iOS mobile app for translating text messages. The application has been optimized for portrait view on iPhones 6 and up.

# Features
* **Firebase** to store data, backup and authenticate users
* **Realm** and **Plist** to store data locally and moniter changes
* **Yandex API** to translate data
* **SwiftyJSON** and **AlamoFire** to handle api requests and converting data
* **SVProgressHUD** and **Dynamic blur view** for miscellaneous animations and views

# Preparing to run
* 'pod install' and 'pod update' need to be run from the main folder to install the required third-party dependencies
* A custom google plist is required to configure firebase in the App Delegate
* The actual code required for the App Delegate is already in the file
* Other settings like bundle identifiers also need to be changed
