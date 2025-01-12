import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../app/app_model.dart';
import '../../app_config.dart';
import '../../common/view/common_widgets.dart';
import '../../common/view/theme.dart';
import '../../extensions/build_context_x.dart';
import '../../l10n/l10n.dart';
import '../settings_model.dart';

class ExposeOnlineSection extends StatefulWidget
    with WatchItStatefulWidgetMixin {
  const ExposeOnlineSection({super.key});

  @override
  State<ExposeOnlineSection> createState() => _ExposeOnlineSectionState();
}

class _ExposeOnlineSectionState extends State<ExposeOnlineSection> {
  late TextEditingController _lastFmApiKeyController;
  late TextEditingController _lastFmSecretController;
  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    final model = di<SettingsModel>();
    _lastFmApiKeyController = TextEditingController(text: model.lastFmApiKey);
    _lastFmSecretController = TextEditingController(text: model.lastFmSecret);

    super.initState();
  }

  @override
  void dispose() {
    _lastFmApiKeyController.dispose();
    _lastFmSecretController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final discordEnabled = allowDiscordRPC
        ? watchPropertyValue((SettingsModel m) => m.enableDiscordRPC)
        : false;

    final lastFmEnabled =
        watchPropertyValue((SettingsModel m) => m.enableLastFmScrobbling);

    return YaruSection(
      headline: Text(l10n.exposeOnlineHeadline),
      margin: const EdgeInsets.only(
        top: kYaruPagePadding,
        right: kYaruPagePadding,
        left: kYaruPagePadding,
      ),
      child: Column(
        children: [
          YaruTile(
            title: Row(
              children: space(
                children: [
                  allowDiscordRPC
                      ? const Icon(
                          TablerIcons.brand_discord_filled,
                        )
                      : Icon(
                          TablerIcons.brand_discord_filled,
                          color: context.theme.disabledColor,
                        ),
                  Text(l10n.exposeToDiscordTitle),
                ],
              ),
            ),
            subtitle: Text(
              allowDiscordRPC
                  ? l10n.exposeToDiscordSubTitle
                  : l10n.featureDisabledOnPlatform,
            ),
            trailing: CommonSwitch(
              value: discordEnabled,
              onChanged: allowDiscordRPC
                  ? (v) {
                      di<SettingsModel>().setEnableDiscordRPC(v);
                      final appModel = di<AppModel>();
                      if (v) {
                        appModel.connectToDiscord();
                      } else {
                        appModel.disconnectFromDiscord();
                      }
                    }
                  : null,
            ),
          ),
          YaruTile(
            title: Row(
              children: space(
                children: [
                  const Icon(
                    TablerIcons.brand_lastfm,
                  ),
                  if (lastFmEnabled &&
                      watchValue((AppModel m) => m.isLastFmAuthorized))
                    Text(l10n.connectedTo),
                  Text(l10n.exposeToLastfmTitle),
                ],
              ),
            ),
            subtitle: Column(
              children: [
                Text(l10n.exposeToLastfmSubTitle),
              ],
            ),
            trailing: CommonSwitch(
              value: lastFmEnabled,
              onChanged: (v) {
                di<SettingsModel>().setEnableLastFmScrobbling(v);
              },
            ),
          ),
          if (lastFmEnabled) ...[
            Padding(
              padding: const EdgeInsets.all(8),
              child: Form(
                key: _formkey,
                onChanged: _formkey.currentState?.validate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: space(
                    heightGap: 10,
                    children: [
                      TextFormField(
                        obscureText: true,
                        controller: _lastFmApiKeyController,
                        decoration: InputDecoration(
                          hintText: l10n.lastfmApiKey,
                          label: Text(l10n.lastfmApiKey),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.lastfmApiKeyEmpty;
                          }
                          return null;
                        },
                        onChanged: (_) => _formkey.currentState?.validate(),
                        onFieldSubmitted: (value) async {
                          if (_formkey.currentState!.validate()) {
                            di<SettingsModel>().setLastFmApiKey(value);
                          }
                        },
                      ),
                      TextFormField(
                        obscureText: true,
                        controller: _lastFmSecretController,
                        decoration: InputDecoration(
                          hintText: l10n.lastfmSecret,
                          label: Text(l10n.lastfmSecret),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.lastfmSecretEmpty;
                          }
                          return null;
                        },
                        onChanged: (_) => _formkey.currentState?.validate(),
                        onFieldSubmitted: (value) async {
                          if (_formkey.currentState!.validate()) {
                            di<SettingsModel>().setLastFmSecret(value);
                          }
                        },
                      ),
                      ImportantButton(
                        onPressed: () {
                          di<SettingsModel>()
                            ..setLastFmApiKey(
                              _lastFmApiKeyController.text,
                            )
                            ..setLastFmSecret(
                              _lastFmSecretController.text,
                            );
                          di<AppModel>().authorizeLastFm(
                            apiKey: _lastFmApiKeyController.text,
                            apiSecret: _lastFmSecretController.text,
                          );
                        },
                        child: Text(l10n.saveAndAuthorize),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
