import 'dart:async';

import 'package:flutter/material.dart';
import 'package:after_layout/after_layout.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:univagenda/keys/route_key.dart';
import 'package:univagenda/keys/string_key.dart';
import 'package:univagenda/screens/appbar_screen.dart';
import 'package:univagenda/screens/base_state.dart';
import 'package:univagenda/utils/analytics.dart';
import 'package:univagenda/utils/translations.dart';
import 'package:univagenda/widgets/ui/button/raised_button_colored.dart';
import 'package:univagenda/widgets/ui/logo.dart';
import 'package:timezone/timezone.dart';

class SplashScreen extends StatefulWidget {
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends BaseState<SplashScreen> with AfterLayoutMixin {
  String _errorMsg;

  @override
  void afterFirstLayout(BuildContext context) {
    _initPreferences();
    AnalyticsProvider.setScreen(widget);
  }

  Future<List<int>> loadDefaultData() async {
    final byteData = await rootBundle.load(
      'packages/timezone/data/2020a_all.tzf',
    );
    return byteData.buffer.asUint8List();
  }

  Future<void> _initPreferences() async {
    // Init translations
    await i18n.init();
    
    // Init timezone
    initializeDatabase(await loadDefaultData());
    setLocalLocation(
      getLocation(await FlutterNativeTimezone.getLocalTimezone()),
    );

    _setError(null);
    _startTimeout();

    final now = DateTime.now();

    // Load preferences from disk
    await prefs.initFromDisk(context, true);

    if (prefs.urlIcs?.trim()?.isEmpty ?? true) {
      prefs.setUserLogged(false);
    }

    final routeDest = (!prefs.isIntroDone)
        ? RouteKey.INTRO
        : (prefs.isUserLogged) ? RouteKey.HOME : RouteKey.LOGIN;

    // Wait minimum 1.5 secondes
    final diffMs = 1000 - DateTime.now().difference(now).inMilliseconds;
    final waitTime = diffMs < 0 ? 0 : diffMs;

    await Future.delayed(Duration(milliseconds: waitTime));
    if (mounted) Navigator.of(context).pushReplacementNamed(routeDest);
  }

  void _startTimeout() async {
    // Start timout of 40sec. If widget still mounted, set error
    // If not mounted anymore, do nothing
    await Future.delayed(const Duration(seconds: 40));
    _setError(StrKey.NETWORK_ERROR);
  }

  void _setError([String msgKey]) {
    if (!mounted) return;
    setState(() => _errorMsg = msgKey != null ? i18n.text(msgKey) : null);
  }

  @override
  Widget build(BuildContext context) {
    return AppbarPage(
      body: Container(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            const Expanded(
              flex: 6,
              child: Center(child: Logo(size: 150.0)),
            ),
            Expanded(
              flex: 4,
              child: Center(
                child: _errorMsg != null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _errorMsg,
                            style: theme.textTheme.subtitle1,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24.0),
                          RaisedButtonColored(
                            text: i18n.text(StrKey.RETRY),
                            onPressed: _initPreferences,
                          ),
                        ],
                      )
                    : const CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
