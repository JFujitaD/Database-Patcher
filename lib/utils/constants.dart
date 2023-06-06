import 'package:flutter/material.dart';

class Constants {
  Constants._();

  static const appName = 'Database Patcher';

  static const addTableTitle = 'New Table';
  static const tableIcon = Icon(Icons.table_bar_outlined);
  static const tableHintText = 'my_table';
  static const tableLabel = 'Table Name';

  static const addColumnIcon = Icon(Icons.add_card_outlined);
  static const removeColumnIcon = Icon(Icons.remove_circle_outline);
  static const columnNameLabel = 'Name';
  static const columnNameHint = 'column_name';
  static const columnNewNameLabel = 'New Name';
  static const columnNewNameHint = 'new_column_name';
  static const columnValueLabel = 'Default Value';
  static const columnValueHint = 'default_value';

  static const generateScriptIcon = Icon(Icons.generating_tokens_outlined);
}