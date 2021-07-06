import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:univagenda/utils/analytics.dart';
import 'package:univagenda/utils/list_colors.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

Brightness getBrightness(bool isDark) =>
    isDark ? Brightness.dark : Brightness.light;

bool isDarkTheme(Brightness brightness) => brightness == Brightness.dark;

Color getColorDependOfBackground(Color bgColor, {Color ifLight, Color ifDark}) {
  return (ThemeData.estimateBrightnessForColor(bgColor) == Brightness.dark)
      ? ifDark ?? Colors.white
      : ifLight ?? Colors.black;
}

Future<void> openLink(BuildContext ctx, String href, String analytic) async {
  if (await canLaunch(href))
    await launch(href);
  else
    Scaffold.of(ctx).showSnackBar(
      SnackBar(content: Text('Could not launch $href')),
    );
  if (ctx != null && analytic != null)
    AnalyticsProvider.sendLinkClicked(analytic);
}

String capitalize(String input) {
  if (input == null) throw ArgumentError("string: $input");
  if (input.isEmpty) return input;
  if (input.length == 1) return input[0].toUpperCase();

  return input[0].toUpperCase() + input.substring(1);
}

Color getColorFromString(String string) {
  List<Color> colors = [];
  for (ColorSwatch colorSwatch in appMaterialColors)
    for (int i = 400; i < 800; i += 200) {
      if (colorSwatch[i] != null) colors.add(colorSwatch[i]);
    }

  var sum = 0;
  string.codeUnits.forEach((code) => sum += code);

  return colors[sum % appMaterialColors.length];
}

Future<String> readFile(String filename, String defaultValue) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    return await File('$path/$filename')?.readAsString() ?? defaultValue;
  } catch (_) {
    return defaultValue;
  }
}

Future<void> writeFile(String filename, dynamic content) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    await File('$path/$filename')?.writeAsString(content);
  } catch (_) {}

  return;
}

bool listEqualsNotOrdered(List a, List b) {
  if (a == null && b == null) return true;
  if (a == null || b == null) return false;
  if (a.length != b.length) return false;

  for (var i = 0; i < a.length; i++) if (b.indexOf(a[i]) == -1) return false;

  return true;
}
