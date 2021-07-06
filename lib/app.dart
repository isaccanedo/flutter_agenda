import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:univagenda/keys/route_key.dart';
import 'package:univagenda/screens/about/aboutscreen.dart';
import 'package:univagenda/screens/about/licences/licences.dart';
import 'package:univagenda/screens/help/help.dart';
import 'package:univagenda/screens/home/home.dart';
import 'package:univagenda/screens/login/login.dart';
import 'package:univagenda/screens/onboarding/onboarding.dart';
import 'package:univagenda/screens/settings/settings.dart';
import 'package:univagenda/screens/splashscreen/splashscreen.dart';
import 'package:univagenda/screens/supportme/supportme.dart';
import 'package:univagenda/utils/custom_route.dart';
import 'package:univagenda/utils/functions.dart';
import 'package:univagenda/utils/preferences.dart';
import 'package:univagenda/utils/translations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

final routes = {
  RouteKey.SPLASHSCREEN: SplashScreen(),
  RouteKey.HOME: HomeScreen(),
  RouteKey.SETTINGS: SettingsScreen(),
  RouteKey.HELP: HelpScreen(),
  RouteKey.ABOUT: AboutScreen(),
  RouteKey.LICENCES: LicencesScreen(),
  RouteKey.INTRO: OnboardingScreen(),
  RouteKey.LOGIN: LoginScreen(),
  RouteKey.SUPPORTME: SupportMeScreen(),
};

class App extends StatelessWidget {
  final SharedPreferences prefs;

  const App({Key key, @required this.prefs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreferencesProvider(
      prefs: prefs,
      child: Builder(
        builder: (context) {
          final themePrefs = PreferencesProvider.of(context).theme;
          final theme = ThemeData(
            platform: TargetPlatform.android,
            fontFamily: 'GoogleSans',
            brightness: getBrightness(themePrefs.darkTheme),
            primaryColor: themePrefs.primaryColor,
            accentColor: themePrefs.accentColor,
            toggleableActiveColor: themePrefs.accentColor,
            textSelectionHandleColor: themePrefs.accentColor,
          );

          SystemUiOverlayStyle style = theme.brightness == Brightness.dark
              ? SystemUiOverlayStyle.light
              : SystemUiOverlayStyle.dark;

          SystemChrome.setSystemUIOverlayStyle(style.copyWith(
            statusBarColor: Colors.transparent,
          ));

          return MaterialApp(
            title: "UnivAgenda",
            theme: theme,
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: i18n.supportedLocales(),
            initialRoute: RouteKey.SPLASHSCREEN,
            onGenerateRoute: (RouteSettings settings) {
              if (routes.containsKey(settings.name))
                return CustomRoute(
                  builder: (_) => routes[settings.name],
                  settings: settings,
                );
              assert(false);
              return null;
            },
          );
        },
      ),
    );
  }
}
