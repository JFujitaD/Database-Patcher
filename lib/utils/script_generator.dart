import '../models/database_table.dart';
import '../models/column_operations.dart';

class ScriptGenerator {
  ScriptGenerator._();

  static void generateScript(List<DatabaseTable> tables) {
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

    print(stringBuffer.toString());
  }
}