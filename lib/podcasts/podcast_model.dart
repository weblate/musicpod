import 'dart:async';

import 'package:safe_change_notifier/safe_change_notifier.dart';

import '../library/library_service.dart';
import 'podcast_service.dart';

class PodcastModel extends SafeChangeNotifier {
  PodcastModel({
    required PodcastService podcastService,
    required LibraryService libraryService,
  })  : _podcastService = podcastService,
        _libraryService = libraryService;

  final PodcastService _podcastService;
  final LibraryService _libraryService;

  bool _loadingFeed = false;
  bool get loadingFeed => _loadingFeed;
  void setLoadingFeed(bool value) {
    if (_loadingFeed == value) return;
    _loadingFeed = value;
    notifyListeners();
  }

  var _firstUpdateChecked = false;
  Future<void> init({
    required String updateMessage,
    bool forceInit = false,
  }) async {
    await _podcastService.init(forceInit: forceInit);

    if (_firstUpdateChecked == false) {
      update(updateMessage);
    }
    _firstUpdateChecked = true;

    notifyListeners();
  }

  void update(String updateMessage) {
    _setCheckingForUpdates(true);
    _podcastService
        .updatePodcasts(
          oldPodcasts: _libraryService.podcasts,
          updatePodcast: _libraryService.updatePodcast,
          updateMessage: updateMessage,
        )
        .then((_) => _setCheckingForUpdates(false));
  }

  bool _checkingForUpdates = false;
  bool get checkingForUpdates => _checkingForUpdates;
  void _setCheckingForUpdates(bool value) {
    if (_checkingForUpdates == value) return;
    _checkingForUpdates = value;
    notifyListeners();
  }

  bool _updatesOnly = false;
  bool get updatesOnly => _updatesOnly;
  void setUpdatesOnly(bool value) {
    if (_updatesOnly == value) return;
    _updatesOnly = value;
    notifyListeners();
  }

  bool _downloadsOnly = false;
  bool get downloadsOnly => _downloadsOnly;
  void setDownloadsOnly(bool value) {
    if (_downloadsOnly == value) return;
    _downloadsOnly = value;
    notifyListeners();
  }
}