import 'dart:async';

import 'package:flutter/material.dart';
import 'package:univagenda/keys/string_key.dart';
import 'package:univagenda/screens/base_state.dart';
import 'package:univagenda/utils/translations.dart';
import 'package:univagenda/widgets/settings/list_tile_title.dart';
import 'package:univagenda/widgets/ui/dialog/dialog_predefined.dart';
import 'package:univagenda/widgets/ui/number_selector.dart';

class ListTileNumber extends StatefulWidget {
  final String title;
  final String subtitle;
  final String titleDialog;
  final ValueChanged<int> onChange;
  final int defaultValue;
  final int minValue;
  final int maxValue;

  const ListTileNumber({
    Key key,
    @required this.title,
    this.subtitle,
    this.titleDialog,
    this.onChange,
    this.defaultValue,
    this.minValue = 0,
    @required this.maxValue,
  })  : assert(title != null),
        assert(maxValue != null && maxValue > minValue),
        super(key: key);

  @override
  _ListTileNumberState createState() => _ListTileNumberState();
}

class _ListTileNumberState extends BaseState<ListTileNumber> {
  int _inputValue;
  int _submitInputValue;

  @override
  void initState() {
    super.initState();
    _initSelectedValue();
  }

  @protected
  void didUpdateWidget(covariant ListTileNumber oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initSelectedValue();
  }

  void _initSelectedValue() {
    setState(() {
      _inputValue = widget.defaultValue ?? widget.minValue;
      _submitInputValue = _inputValue;
    });
  }

  void _onInputChange(value) {
    setState(() => _inputValue = value);
  }

  void _onSubmit() {
    widget.onChange(_inputValue);
    setState(() => _submitInputValue = _inputValue);
  }

  Future<Null> _openDialog() async {
    setState(() => _inputValue = _submitInputValue);

    bool isDialogPositive = await DialogPredefined.showContentDialog(
        context,
        widget.titleDialog ?? widget.title,
        NumberSelector(
          min: widget.minValue,
          max: widget.maxValue,
          initialValue: _inputValue,
          onChanged: _onInputChange,
        ),
        i18n.text(StrKey.SUBMIT),
        i18n.text(StrKey.CANCEL),
        true,
        const EdgeInsets.all(0.0));

    if (isDialogPositive) _onSubmit();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: ListTileTitle(widget.title),
      subtitle: Text(widget.subtitle ?? _submitInputValue.toString()),
      onTap: _openDialog,
    );
  }
}
