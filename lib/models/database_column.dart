import './data_types.dart';
import './column_operations.dart';

class DatabaseColumn {
  final String name;
  ColumnOperations columnOperation = ColumnOperations.none;
  DataTypes? dataType;
  String? value;

  DatabaseColumn({required this.name, this.dataType, this.value});
}