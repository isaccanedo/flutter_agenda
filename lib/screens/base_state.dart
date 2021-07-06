import 'package:flutter/material.dart';
import 'package:univagenda/utils/preferences.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T> {
  PreferencesProviderState prefs;
  ThemeData theme;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    prefs = PreferencesProvider.of(context);
    theme = Theme.of(context);
  }
}
