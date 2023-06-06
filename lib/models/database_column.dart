import './data_types.dart';

class DatabaseColumn {
  final String name;
  DataTypes? dataType;
  String? value;

  DatabaseColumn({required this.name, this.dataType, this.value});
}