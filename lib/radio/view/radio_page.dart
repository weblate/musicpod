import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../app/connectivity_model.dart';
import '../../app/view/music_pod_scaffold.dart';
import '../../common/data/audio.dart';
import '../../common/view/header_bar.dart';
import '../../common/view/offline_page.dart';
import '../../common/view/search_button.dart';
import '../../common/view/theme.dart';
import '../../constants.dart';
import '../../l10n/l10n.dart';
import '../../library/library_model.dart';
import '../../search/search_model.dart';
import '../../search/search_type.dart';
import '../../settings/view/settings_action.dart';
import 'radio_lib_page.dart';

class RadioPage extends StatelessWidget with WatchItMixin {
  const RadioPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isOnline = watchPropertyValue((ConnectivityModel m) => m.isOnline);
    if (!isOnline) return const OfflinePage();

    return MusicPodScaffold(
      appBar: HeaderBar(
        adaptive: true,
        actions: [
          if (isMobile) const SettingsButton.icon(),
          Flexible(
            child: Padding(
              padding: appBarSingleActionSpacing,
              child: SearchButton(
                active: false,
                onPressed: () {
                  di<LibraryModel>().push(pageId: kSearchPageId);
                  final searchModel = di<SearchModel>();
                  if (searchModel.audioType != AudioType.radio) {
                    searchModel
                      ..setAudioType(AudioType.radio)
                      ..setSearchType(SearchType.radioName)
                      ..setSearchQuery('')
                      ..search(clear: true);
                  }
                },
              ),
            ),
          ),
        ],
        title: Text('${context.l10n.radio} ${context.l10n.collection}'),
      ),
      body: const RadioLibPage(),
    );
  }
}
