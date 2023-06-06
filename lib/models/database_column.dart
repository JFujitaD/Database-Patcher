import './data_types.dart';
import './column_operations.dart';

class DatabaseColumn {
  String? name;
  ColumnOperations columnOperation = ColumnOperations.none;
  DataTypes dataType = DataTypes.none;
  String? value;
}