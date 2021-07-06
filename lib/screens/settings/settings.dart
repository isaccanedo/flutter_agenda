import 'package:flutter/material.dart';
import 'package:univagenda/keys/pref_key.dart';
import 'package:univagenda/keys/string_key.dart';
import 'package:univagenda/screens/appbar_screen.dart';
import 'package:univagenda/screens/base_state.dart';
import 'package:univagenda/screens/settings/manage_hidden_events.dart';
import 'package:univagenda/utils/analytics.dart';
import 'package:univagenda/utils/custom_route.dart';
import 'package:univagenda/utils/translations.dart';
import 'package:univagenda/widgets/settings/list_tile_color.dart';
import 'package:univagenda/widgets/settings/list_tile_input.dart';
import 'package:univagenda/widgets/settings/list_tile_number.dart';
import 'package:univagenda/widgets/settings/list_tile_title.dart';
import 'package:univagenda/widgets/settings/setting_card.dart';
import 'package:univagenda/widgets/ui/list_divider.dart';

enum MenuItem { REFRESH }

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends BaseState<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    AnalyticsProvider.setScreen(widget);
  }

  Widget _buildSettingsGeneral() {
    List<Widget> settingsGeneralElems;

    settingsGeneralElems = [
      ListTileInput(
        title: i18n.text(StrKey.URL_ICS),
        hintText: i18n.text(StrKey.URL_ICS),
        defaultValue: prefs.urlIcs,
        onChange: (value) {
          prefs.setCachedCourses(PrefKey.defaultCachedCourses);
          prefs.setUrlIcs(value, true);
        },
      )
    ];

    return SettingCard(
      header: i18n.text(StrKey.SETTINGS_GENERAL),
      children: settingsGeneralElems,
    );
  }

  Widget _buildSettingsDisplay() {
    List<Widget> settingsDisplayItems = [
      ListTileNumber(
        title: i18n.text(StrKey.NUMBER_WEEK),
        subtitle: i18n.text(
          prefs.numberWeeks > 1
              ? StrKey.NUMBER_WEEK_DESC_PLURAL
              : StrKey.NUMBER_WEEK_DESC_ONE,
          {'nbWeeks': prefs.numberWeeks},
        ),
        defaultValue: prefs.numberWeeks,
        minValue: 1,
        maxValue: 16,
        onChange: (value) => prefs.setNumberWeeks(value, true),
      ),
      SwitchListTile(
        title: ListTileTitle(i18n.text(StrKey.DAYS_BEFORE)),
        subtitle: Text(i18n.text(StrKey.DAYS_BEFORE_DESC)),
        value: prefs.isPreviousCourses,
        activeColor: theme.accentColor,
        onChanged: (value) => prefs.setShowPreviousCourses(value, true),
      ),
      SwitchListTile(
        title: ListTileTitle(i18n.text(StrKey.DISPLAY_ALL_DAYS)),
        subtitle: Text(i18n.text(StrKey.DISPLAY_ALL_DAYS_DESC)),
        value: prefs.isDisplayAllDays,
        activeColor: theme.accentColor,
        onChanged: (value) => prefs.setDisplayAllDays(value, true),
      ),
      SwitchListTile(
        title: ListTileTitle(i18n.text(StrKey.HIDDEN_EVENT)),
        subtitle: Text(i18n.text(StrKey.FULL_HIDDEN_EVENT_DESC)),
        value: prefs.isFullHiddenEvent,
        activeColor: theme.accentColor,
        onChanged: (value) => prefs.setFullHiddenEvent(value, true),
      ),
      ListTile(
        title: ListTileTitle(i18n.text(StrKey.MANAGE_HIDDEN_EVENT)),
        subtitle: Text(i18n.text(StrKey.MANAGE_HIDDEN_EVENT_DESC)),
        onTap: () {
          Navigator.of(context).push(
            CustomRoute(
              fullscreenDialog: true,
              builder: (_) => ManageHiddenEvents(),
            ),
          );
        },
      )
    ];

    return SettingCard(
      header: i18n.text(StrKey.SETTINGS_DISPLAY),
      children: settingsDisplayItems,
    );
  }

  Widget _buildSettingsColors() {
    return SettingCard(
      header: i18n.text(StrKey.SETTINGS_COLORS),
      children: [
        SwitchListTile(
          title: ListTileTitle(i18n.text(StrKey.DARK_THEME)),
          subtitle: Text(i18n.text(StrKey.DARK_THEME_DESC)),
          value: prefs.theme.darkTheme,
          activeColor: theme.accentColor,
          onChanged: (value) => prefs.setDarkTheme(value, true),
        ),
        const ListDivider(),
        ListTileColor(
          title: i18n.text(StrKey.PRIMARY_COLOR),
          description: i18n.text(StrKey.PRIMARY_COLOR_DESC),
          selectedColor: prefs.theme.primaryColor,
          onColorChange: (color) => prefs.setPrimaryColor(color, true),
        ),
        const ListDivider(),
        ListTileColor(
          title: i18n.text(StrKey.ACCENT_COLOR),
          description: i18n.text(StrKey.ACCENT_COLOR_DESC),
          selectedColor: prefs.theme.accentColor,
          onColorChange: (color) => prefs.setAccentColor(color, true),
          colors: [
            Colors.redAccent,
            Colors.pinkAccent,
            Colors.purpleAccent,
            Colors.deepPurpleAccent,
            Colors.indigoAccent,
            Colors.blueAccent,
            Colors.lightBlueAccent,
            Colors.cyanAccent,
            Colors.tealAccent,
            Colors.greenAccent,
            Colors.lightGreenAccent,
            Colors.limeAccent,
            Colors.yellowAccent,
            Colors.amberAccent,
            Colors.orangeAccent,
            Colors.deepOrangeAccent,
            Colors.brown,
            Colors.grey,
            Colors.blueGrey
          ],
        ),
        const ListDivider(),
        ListTileColor(
          title: i18n.text(StrKey.NOTE_COLOR),
          description: i18n.text(StrKey.NOTE_COLOR_DESC),
          selectedColor: prefs.theme.noteColor,
          onColorChange: (color) => prefs.setNoteColor(color, true),
        ),
        SwitchListTile(
          title: ListTileTitle(i18n.text(StrKey.GENERATE_EVENT_COLOR)),
          subtitle: Text(i18n.text(StrKey.GENERATE_EVENT_COLOR_TEXT)),
          value: prefs.isGenerateEventColor,
          activeColor: Theme.of(context).accentColor,
          onChanged: (value) => prefs.setGenerateEventColor(value, true),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppbarPage(
      title: i18n.text(StrKey.SETTINGS),
      body: ListView(
        children: [
          _buildSettingsGeneral(),
          _buildSettingsDisplay(),
          _buildSettingsColors()
        ],
      ),
    );
  }
}
