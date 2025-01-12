# MusicPod

MusicPod is a local music, radio, television and podcast player for Linux Desktop, MacOS and Windows. (Android is planed but no ETA yet when it will happen.)

|OS|How to install|
|-|-|
|Linux|[![Get it from the Snap Store](https://snapcraft.io/static/images/badges/en/snap-store-black.svg)](https://snapcraft.io/musicpod) <br/> or <br/> [![](https://flathub.org/api/badge?locale=en)](https://flathub.org/apps/org.feichtmeier.Musicpod)|
|Windows|[Release Page](https://github.com/ubuntu-flutter-community/musicpod/releases)|
|MacOS|[Release Page](https://github.com/ubuntu-flutter-community/musicpod/releases)|
|Android|WIP|


## Features

|Features | Dark Linux | Light Linux | Dark MacOS | Light MacOS | 
|-|-|-|-|-|
|Play local audio|![](.github/images/album_dark_linux.png)|![](.github/images/album_light_linux.png)|![](.github/images/album_dark_macos.png)|![](.github/images/album_light_macos.png)|
|Find local audios sorted by [Metadata](https://github.com/ClementBeal/audio_metadata_reader) |![](.github/images/albums_dark_linux.png)|![](.github/images/albums_light_linux.png)|![](.github/images/albums_dark_macos.png)|![](.github/images/albums_light_macos.png)|
|Play radio stations, with icytags and artwork looked up!|![](.github/images/station_dark_linux.png)|![](.github/images/station_light_linux.png)|![](.github/images/station_dark_macos.png)|![](.github/images/station_light_macos.png)|
|Play and download podcasts, safe progress, sort episodes and more!|![](.github/images/podcast_dark_linux.png)|![](.github/images/podcast_light_linux.png)|![](.github/images/podcast_dark_macos.png)|![](.github/images/podcast_light_macos.png)|
|Video podcast support!|![](.github/images/video_dark_linux.png)|![](.github/images/video_light_linux.png)|![](.github/images/video_dark_macos.png)|![](.github/images/video_light_macos.png)|
|Discover podcasts, filtered as you like|![](.github/images/podcasts_dark_linux.png)|![](.github/images/podcasts_light_linux.png)|![](.github/images/podcasts_dark_macos.png)|![](.github/images/podcasts_light_macos.png)|
|Discover radio stations, filtered as you like|![](.github/images/radio_dark_linux.png)|![](.github/images/radio_light_linux.png)|![](.github/images/radio_dark_macos.png)|![](.github/images/radio_light_macos.png)|
|Different view modes|![](.github/images/fullheight_dark_linux.png)|![](.github/images/fullheight_light_linux.png)|![](.github/images/fullheight_dark_macos.png)|![](.github/images/fullheight_light_macos.png)|


## Credits

### AppIcon

The app icon has been made by [Stuart Jaggers](https://github.com/ubuntujaggers), thank you very much Stuart!

### Flatpak

Thanks [TheShadowOfHassen](https://github.com/TheShadowOfHassen) for packaging MusicPod as a  [Flatpak](https://flathub.org/apps/org.feichtmeier.Musicpod)!

### Libraries used

Thanks to all the [MPV](https://github.com/mpv-player/mpv) contributors!

Thank you [@amugofjava](https://github.com/amugofjava) for creating the very easy to use and reliable [podcast_search](https://github.com/amugofjava/podcast_search)!

Thanks [@alexmercerind](https://github.com/alexmercerind) for the super performant [Mediakit library](https://github.com/alexmercerind/media_kit) and [mpris_service](https://github.com/alexmercerind/mpris_service) dart implementation!

Thank you [@KRTirtho](https://github.com/KRTirtho) for the very easy to use [smtc_windows](https://github.com/KRTirtho/frb_plugins) package and [Flutter Discord RPC](https://github.com/KRTirtho/frb_plugins)

Thank you [@tomassasovsky](https://github.com/tomassasovsky) for the [dart implementation of radiobrowser-api](https://github.com/tomassasovsky/radio-browser-api.dart)!

Thank you [@ClementBeal](https://github.com/ClementBeal) for the super fast, pure dart [Audio Metadata Reader](https://github.com/ClementBeal/audio_metadata_reader)!

Thank you [@escamoteur](https://github.com/escamoteur) for creating [get_it](https://pub.dev/packages/get_it) and [watch_it](https://pub.dev/packages/watch_it), which made my application faster and the source code cleaner!

## Contributing

Contributions are highly welcome. Especially translations.
Please [fork](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/working-with-forks/fork-a-repo) MusicPod to your GitHub namespace, [clone](https://docs.github.com/de/repositories/creating-and-managing-repositories/cloning-a-repository) it to your computer, create a branch named by yourself, commit your changes to your local branch, push them to your fork and then make a pull request from your fork to this repository.
I recommend the vscode extension [GitHub Pull Requests](https://marketplace.visualstudio.com/items?itemName=GitHub.vscode-pull-request-github) especially for people new to [Git](https://git-scm.com/doc) and [GitHub](https://docs.github.com/en/get-started/start-your-journey).

## Translations
For translations into your language change the corresponding `app_xx.arb` file where `xx` is the language code of your language in lower case.
If the file does not exist yet please create it and copy the `whole` content of app_en.arb into it and change only the values to your translation but leave the keys untouched.
The vscode extension [arb editor by Google](https://marketplace.visualstudio.com/items?itemName=Google.arb-editor) is highly recommended to avoid arb syntax errors.
Also recommended is the [Google Translate Extension](https://marketplace.visualstudio.com/items?itemName=funkyremi.vscode-google-translate).

## Code contributions

If you find any error please feel free to report it as an issue and describe it as good as you can.
If you want to contribute code, please create an issue first.

## Testing

Test mocks are generated with [Mockito](https://github.com/dart-lang/mockito). You need to run the `build_runner` command in order to re-generate mocks, in case you changed the signatures of service methods.

`dart run build_runner build`

## Boring developer things

### Under the flutter hood

MusicPod is basically a fancy front-end for [MPV](https://github.com/mpv-player/mpv)! Without it it would still look nice, but it wouldn't play any media :D!

### Architecture: [model, view, viewmodel (MVVM)](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93viewmodel)

MusicPod uses the MVVM architectural pattern, which fits the needs of this reactive app the most, and keeps all layers separated so we can exchange the implementation of one layer if we need to. [MVVM is also recommended by Flutter itself](https://docs.flutter.dev/get-started/fwe/state-management#using-mvvm-for-your-applications-architecture).

The app, the player, the search and each main page have their own set of widgets, one or more view model, which depend on one or more services.

All services and ViewModels are registered lazily via [get_it](https://pub.dev/packages/get_it), which means they are not instantiated until they are located for the first time via `di<XyzService>` or `di<ViewModel>`.

```mermaid

flowchart LR

classDef view fill:#0e84207d
classDef viewmodel fill:#e9542080
classDef model fill:#77216f80

View["`
  **View**
  (Widgets)
`"]:::view--watchProperty-->ViewModel["`
  **ViewModel**
  (ChangeNotifier)
`"]:::viewmodel--listen/get properties-->Model["`
  **(Domain) Model**
  (Service)
`"]:::model

ViewModel--notify-->View
Model--changedProperties.add(true)-->ViewModel

```

The ViewModels have a dependencies to services which are given via their constructor, where they are located via the service locator [get_it](https://pub.dev/packages/get_it). This makes them easy to test since you can replace the services with mocked services.

The ViewModels are [ChangeNotifiers](https://api.flutter.dev/flutter/foundation/ChangeNotifier-class.html). They can use the `notifyListener` method which makes listeners (concrete: UI classes) react (i.e. rebuild).

The ViewModels hold (a) [StreamSubscription(s)](https://api.flutter.dev/flutter/dart-async/StreamSubscription-class.html) to (the) service(s) they depend on. If properties are only non-persistent UI state, they are hold inside the ViewModel. If they are more than that, they are just getters to service properties.
So if a property of a service changes, the ViewModels will be notified via the propertiesChanged stream, and if we want the UI to take notice, inside the `listen` callback we will notify the UI (listeners).

### Dependency choices, service locator and state management

Regarding the packages to implement this architecture I've had quite a journey from [provider](https://pub.dev/packages/provider) to [riverpod](https://pub.dev/packages/riverpod).

I found my personal favorite solution with [get_it](https://pub.dev/packages/get_it) plus its [watch_it](https://pub.dev/packages/watch_it) extension because this fits the need of this application and the [MVVM-architecture](https://docs.flutter.dev/get-started/fwe/state-management#using-mvvm-for-your-applications-architecture) the most without being too invasive into the API of the flutter widget tree.

This way all layers are clearly separated, easy to re-implement and easy to follow, even if this brings a little bit of boilerplate code.

## Watching the ViewModels inside the View (Widgets)

If the Widgets want to be rebuilt once properties of ViewModels change, we use the `watchPropertyValue` method of the [watch_it](https://pub.dev/packages/watch_it) package:

```dart
final audio = watchPropertyValue((PlayerModel m) => m.audio);
```

This makes it easier, even though we could also just use flutters built in [ListenableBuilder](https://api.flutter.dev/flutter/widgets/ListenableBuilder-class.html).

### Caching

Both local covers and remote covers are cached in a `CoverStore` and a `UrlStore` after they have been loaded/fetched.

### Performance

Reading the local covers and fetching remote covers for radio data happens inside additional second [dart isolates](https://dart.dev/language/isolates).

### Persistence

Preferences are stored with [shared_preferences](https://pub.dev/packages/shared_preferences).