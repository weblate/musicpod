import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/constants.dart';

import '../../app/connectivity_model.dart';
import '../../app_config.dart';
import '../../common/data/audio.dart';
import '../../common/view/icons.dart';
import '../../l10n/l10n.dart';
import '../player_model.dart';
import 'full_height_player_top_controls.dart';
import 'player_main_controls.dart';
import 'player_view.dart';

class FullHeightVideoPlayer extends StatelessWidget with WatchItMixin {
  const FullHeightVideoPlayer({super.key, required this.playerPosition});

  final PlayerPosition playerPosition;

  @override
  Widget build(BuildContext context) {
    const baseColor = Colors.white;

    final audio = watchPropertyValue((PlayerModel m) => m.audio);
    final isOnline = watchPropertyValue((ConnectivityModel m) => m.isOnline);
    final active = audio?.path != null || isOnline;

    final controls = FullHeightPlayerTopControls(
      iconColor: baseColor,
      playerPosition: playerPosition,
      padding: EdgeInsets.zero,
    );

    final text = audio?.audioType == AudioType.radio
        ? audio?.title ?? ''
        : '${audio?.title == null ? '' : '${audio!.title}'} - ${audio?.album == null ? '' : '${audio!.album}'} - ${audio?.artist == null ? '' : '${audio!.artist}'}';
    final mediaKitTheme = MaterialVideoControlsThemeData(
      seekBarThumbColor: baseColor,
      seekBarColor: baseColor.withOpacity(0.3),
      seekBarPositionColor: baseColor.withOpacity(0.9),
      seekBarBufferColor: baseColor.withOpacity(0.6),
      buttonBarButtonColor: baseColor,
      controlsHoverDuration: const Duration(seconds: 10),
      seekGesture: true,
      seekOnDoubleTap: true,
      primaryButtonBar: [
        SizedBox(
          width: 300,
          child: PlayerMainControls(
            active: active,
            iconColor: baseColor,
            avatarColor: baseColor.withOpacity(0.1),
          ),
        ),
      ],
      seekBarMargin: const EdgeInsets.all(kYaruPagePadding),
      topButtonBarMargin: const EdgeInsets.only(right: kYaruPagePadding),
      topButtonBar: [
        const Spacer(),
        controls,
        if (allowVideoFullScreen)
          Tooltip(
            message: context.l10n.leaveFullScreen,
            child: MaterialFullscreenButton(
              icon: Icon(
                Iconz.fullScreenExit,
                color: baseColor,
              ),
            ),
          ),
      ],
      bottomButtonBarMargin: const EdgeInsets.all(20),
      bottomButtonBar: [
        Flexible(
          child: Tooltip(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            message: text,
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
      padding: const EdgeInsets.all(20),
    );

    return MaterialVideoControlsTheme(
      key: ValueKey(audio?.url),
      fullscreen: mediaKitTheme,
      normal: mediaKitTheme.copyWith(
        topButtonBar: [
          const Spacer(),
          controls,
          if (allowVideoFullScreen)
            Tooltip(
              message: context.l10n.fullScreen,
              child: MaterialFullscreenButton(
                icon: Icon(
                  Iconz.fullScreen,
                  color: baseColor,
                ),
              ),
            ),
        ],
      ),
      child: RepaintBoundary(
        child: Video(
          controller: di<PlayerModel>().controller,
          controls: (state) => MaterialVideoControls(state),
        ),
      ),
    );
  }
}
