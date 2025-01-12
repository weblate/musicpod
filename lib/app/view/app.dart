import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:phoenix_theme/phoenix_theme.dart' hide ColorX;
import 'package:system_theme/system_theme.dart';
import 'package:watch_it/watch_it.dart';
import 'package:yaru/yaru.dart';

import '../../common/view/theme.dart';
import '../../constants.dart';
import '../../external_path/external_path_service.dart';
import '../../l10n/l10n.dart';
import '../../library/library_model.dart';
import '../../radio/radio_model.dart';
import '../../settings/settings_model.dart';
import '../connectivity_model.dart';
import 'desktop_scaffold.dart';
import 'master_items.dart';
import 'splash_screen.dart';

class YaruMusicPodApp extends StatelessWidget {
  const YaruMusicPodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return YaruTheme(
      builder: (context, yaru, child) => _DesktopMusicPodApp(
        highContrastTheme: yaruHighContrastLight,
        highContrastDarkTheme: yaruHighContrastDark,
        lightTheme: yaruLightWithTweaks(yaru),
        darkTheme: yaruDarkWithTweaks(yaru),
      ),
    );
  }
}

class MaterialMusicPodApp extends StatelessWidget {
  const MaterialMusicPodApp({super.key});

  @override
  Widget build(BuildContext context) => SystemThemeBuilder(
        builder: (context, accent) {
          return isMobile
              ? _MobileMusicPodApp(accent: accent.accent)
              : _DesktopMusicPodApp(accent: accent.accent);
        },
      );
}

class _DesktopMusicPodApp extends StatefulWidget
    with WatchItStatefulWidgetMixin {
  const _DesktopMusicPodApp({
    this.lightTheme,
    this.darkTheme,
    this.accent,
    this.highContrastTheme,
    this.highContrastDarkTheme,
  });

  final ThemeData? lightTheme,
      darkTheme,
      highContrastTheme,
      highContrastDarkTheme;
  final Color? accent;

  @override
  State<_DesktopMusicPodApp> createState() => _DesktopMusicPodAppState();
}

class _DesktopMusicPodAppState extends State<_DesktopMusicPodApp> {
  late Future<bool> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = _init();
  }

  Future<bool> _init() async {
    await di<ConnectivityModel>().init();
    await di<LibraryModel>().init();
    await di<RadioModel>().init();
    if (!mounted) return false;
    di<ExternalPathService>().init();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final themeIndex = watchPropertyValue((SettingsModel m) => m.themeIndex);
    final phoenix = phoenixTheme(color: widget.accent ?? Colors.greenAccent);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.values[themeIndex],
      highContrastTheme: widget.highContrastTheme,
      highContrastDarkTheme: widget.highContrastDarkTheme,
      theme: widget.lightTheme ?? phoenix.lightTheme,
      darkTheme: widget.darkTheme ?? phoenix.darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: supportedLocales,
      onGenerateTitle: (context) => kAppTitle,
      home: FutureBuilder(
        future: _initFuture,
        builder: (context, snapshot) {
          return snapshot.data == true
              ? const DesktopScaffold()
              : const SplashScreen();
        },
      ),
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown,
          PointerDeviceKind.trackpad,
        },
      ),
    );
  }
}

class _MobileMusicPodApp extends StatefulWidget
    with WatchItStatefulWidgetMixin {
  const _MobileMusicPodApp({this.accent});

  final Color? accent;

  @override
  State<_MobileMusicPodApp> createState() => _MobileMusicPodAppState();
}

class _MobileMusicPodAppState extends State<_MobileMusicPodApp> {
  late Future<bool> _initFuture;

  @override
  void initState() {
    super.initState();
    _initFuture = _init();
  }

  Future<bool> _init() async {
    await di<ConnectivityModel>().init();
    await di<LibraryModel>().init();
    await di<RadioModel>().init();
    if (!mounted) return false;
    di<ExternalPathService>().init();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final themeIndex = watchPropertyValue((SettingsModel m) => m.themeIndex);
    final phoenix = phoenixTheme(color: widget.accent ?? Colors.greenAccent);

    final libraryModel = watchIt<LibraryModel>();
    final masterItems = createMasterItems(libraryModel: libraryModel);

    return MaterialApp(
      navigatorKey: libraryModel.masterNavigatorKey,
      navigatorObservers: [libraryModel],
      initialRoute:
          isMobile ? (libraryModel.selectedPageId ?? kSearchPageId) : null,
      onGenerateRoute: (settings) {
        final page = (masterItems.firstWhereOrNull(
                  (e) => e.pageId == settings.name,
                ) ??
                masterItems.elementAt(0))
            .pageBuilder(context);

        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => FutureBuilder(
            future: _initFuture,
            builder: (context, snapshot) {
              return snapshot.data == true ? page : const SplashScreen();
            },
          ),
          transitionsBuilder: (_, a, __, c) =>
              FadeTransition(opacity: a, child: c),
        );
      },
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.values[themeIndex],
      theme: phoenix.lightTheme,
      darkTheme: phoenix.darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: supportedLocales,
      onGenerateTitle: (context) => kAppTitle,
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown,
          PointerDeviceKind.trackpad,
        },
      ),
    );
  }
}
