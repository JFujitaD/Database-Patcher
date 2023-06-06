import '../models/database_table.dart';
import '../models/column_operations.dart';
import '../models/data_types.dart';

class ScriptGenerator {
  ScriptGenerator._();

  static const missingColumnOperation = 'Operation must be chosen for each column';
  static const missingColumnName = 'Columns must have a name';
  static const missingDataType = 'Data Type must be chosen for each column with the ADD or MODIFY operation';
  static const missingNewColumnName = 'New Name must be chosen for each column with the MODIFY operation';
  static const missingDefaultValue = 'Default Value must be chosen for each column with the ADD operation';
  static const missingColumns = 'There must be at least one column per table';

  static String tryGenerateScript(List<DatabaseTable> tables) {
    for (var table in tables) {
      // Check for at least one column in table
      if (table.columns.isEmpty) {
        return missingColumns;
      }

      for (var column in table.columns) {
        // Check for column operation
        if (column.columnOperation == ColumnOperations.none) {
          return missingColumnOperation;
        }
        // Check for column name
        if (column.name == null || column.name!.isEmpty) {
          return missingColumnName;
        }
        // Check if DataType exists for columns with ADD or MODIFY operation
        if (column.columnOperation == ColumnOperations.add || column.columnOperation == ColumnOperations.modify) {
          if (column.dataType == DataTypes.none) {
            return missingDataType;
          }
        }
        // Check for new column name for columns with MODIFY operation
        if (column.columnOperation == ColumnOperations.modify) {
          if (column.newName == null || column.newName!.isEmpty) {
            return missingNewColumnName;
          }
        }
        // Check for default value in ADD operations
        if (column.columnOperation == ColumnOperations.add) {
          if (column.value == null || column.value!.isEmpty) {
            return missingDefaultValue;
          }
        }
      }
    }
    return '';
  }

  static String generateScript(List<DatabaseTable> tables) {
    StringBuffer stringBuffer = StringBuffer();

    for(var table in tables) {
      for (var column in table.columns) {
        stringBuffer.write('ALTER TABLE ${table.name}\n');
        switch (column.columnOperation) {
          case ColumnOperations.add:
            stringBuffer.write('ADD ${column.name} ${column.dataType.name.toUpperCase()};\n\n');
            stringBuffer.write('UPDATE ${table.name}\n');
            stringBuffer.write('SET ${column.name} = ${column.value};\n');
            break;
          case ColumnOperations.remove:
            stringBuffer.write('DROP COLUMN IF EXISTS ${column.name};\n');
            break;
          case ColumnOperations.modify:
            stringBuffer.write('RENAME COLUMN ${column.name} TO ${column.newName};\n\n');
            stringBuffer.write('ALTER TABLE ${table.name}\n');
            stringBuffer.write('ALTER COLUMN ${column.newName} TYPE ${column.dataType.name.toUpperCase()};\n');
            break;
          default:
            stringBuffer.write('INVALID OPERATION\n');
            break;
        }
        stringBuffer.write('\n');
      }
    }

    return stringBuffer.toString();
  }
}