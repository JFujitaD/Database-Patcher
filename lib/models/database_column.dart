import './data_types.dart';
import './column_operations.dart';

class DatabaseColumn {
  String? name;
  String? newName;
  ColumnOperations columnOperation = ColumnOperations.none;
  DataTypes dataType = DataTypes.none;
  String? value;
}