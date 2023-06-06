import 'database_column.dart';

class DatabaseTable {
  final String name;
  final List<DatabaseColumn> columns = [];

  DatabaseTable({required this.name});

  String get tableName => name;
}