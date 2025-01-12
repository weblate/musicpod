import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../app/view/music_pod_scaffold.dart';
import '../../common/data/audio.dart';
import '../../common/view/header_bar.dart';
import '../../common/view/search_button.dart';
import '../../common/view/theme.dart';
import '../../constants.dart';
import '../../l10n/l10n.dart';
import '../../library/library_model.dart';
import '../../search/search_model.dart';
import '../../search/search_type.dart';
import '../../settings/view/settings_action.dart';
import '../podcast_model.dart';
import 'podcasts_collection_body.dart';

class PodcastsPage extends StatefulWidget {
  const PodcastsPage({super.key});

  @override
  State<PodcastsPage> createState() => _PodcastsPageState();
}

class _PodcastsPageState extends State<PodcastsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      di<PodcastModel>().init(
        updateMessage: context.l10n.newEpisodeAvailable,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return MusicPodScaffold(
      appBar: HeaderBar(
        titleSpacing: 0,
        adaptive: true,
        actions: [
          if (isMobile) const SettingsButton.icon(),
          Padding(
            padding: appBarSingleActionSpacing,
            child: SearchButton(
              onPressed: () {
                final searchModel = di<SearchModel>();
                di<LibraryModel>().push(pageId: kSearchPageId);
                if (searchModel.audioType != AudioType.podcast) {
                  searchModel
                    ..setAudioType(AudioType.podcast)
                    ..setSearchType(SearchType.podcastTitle)
                    ..search();
                }
              },
            ),
          ),
        ],
        title: Text('${context.l10n.podcasts} ${context.l10n.collection}'),
      ),
      body: const PodcastsCollectionBody(),
    );
  }
}
