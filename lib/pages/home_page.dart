import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../utils/script_generator.dart';
import '../components/dialog_builder.dart';
import '../models/database_table.dart';
import '../models/database_column.dart';
import '../models/column_operations.dart';
import '../models/data_types.dart';
import '../pages/script_page.dart';
import '../components/app_bar_builder.dart';
import '../utils/app_theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final formKey = GlobalKey<FormState>();
  final tableTextEditingController = TextEditingController();
  List<DatabaseTable> tables = [
    DatabaseTable(name: 'Entries'),
  ];

  void addTable(DatabaseTable newTable) {
    setState(() {
      tables.add(newTable);
    });
  }

  void addColumn(DatabaseTable table) {
    setState(() {
      table.columns.add(DatabaseColumn());
    });
  }

  void removeColumn(DatabaseTable table, DatabaseColumn column) {
    setState(() {
      table.columns.remove(column);
    });
  }

  void changeColumnOperation(DatabaseColumn column, ColumnOperations columnOperation) {
    setState(() {
      column.columnOperation = columnOperation;
    });
  }

  void changeColumnDataType(DatabaseColumn column, DataTypes dataType) {
    setState(() {
      column.dataType = dataType;
    });
  }

  void updateColumnName(DatabaseColumn column, String columnName) {
    column.name = columnName;
  }

  void updateColumnValue(DatabaseColumn column, String value) {
    column.value = value;
  }

  void updateNewColumnName(DatabaseColumn column, String newColumnName) {
    column.newName = newColumnName;
  }

  @override
  void dispose() { 
    super.dispose();
    tableTextEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBuilder.buildAppBar(),
      floatingActionButton: buildFloatingActionButton(),
      body: buildListView(context),
    );
  }

  FloatingActionButton buildFloatingActionButton() => FloatingActionButton(
    onPressed: () {
      var response = ScriptGenerator.tryGenerateScript(tables);
      if (response == '') {
        String script = ScriptGenerator.generateScript(tables);
        Navigator.of(context).push(MaterialPageRoute(
          builder:(context) => ScriptPage(script: script,),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(response),
        ));
      }
    },
    child: Constants.generateScriptIcon,
  );

  Widget buildListView(BuildContext context) {
    final itemCount = tables.length;
    return ListView.builder(
      itemCount: itemCount + 1,
      itemBuilder: (context, index) {
        if (index >= tables.length) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: Constants.spacingVertical, horizontal: Constants.spacingHorizontal),
            child: ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => DialogBuilder.addTableDialog(
                    context,
                    formKey,
                    tableTextEditingController,
                  ),
                ).then((newTable) => addTable(newTable));
              },
              child: const Text('Add New Table'),
            ),
          );
        }

        final t = tables[index];
        return Card(
          child: ExpansionTile(
            onExpansionChanged: (value) => setState(() {}),
            leading: Constants.tableIcon,
            title: Text(t.tableName),
            children: buildExpansionTileChildren(t),
          ),
        );
      },
    );
  }

  List<Widget> buildExpansionTileChildren(DatabaseTable databaseTable) {
    final List<Widget> tileChildren = databaseTable.columns.map<Widget>(
      (column) => Card(
        child: Padding(
          padding: const EdgeInsets.all(Constants.cardPadding),
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildColumnOperationDropdownButton(column),
                const SizedBox(height: Constants.spacingVertical),
                ...buildCustomizedColumn(column),
              ],
            ),
            trailing: IconButton(
              icon: Constants.removeColumnIcon,
              onPressed: () {
                removeColumn(databaseTable, column);
              },
            ),
          ),
        ),
      )
    ).toList();

    tileChildren.add(const SizedBox(height: Constants.spacingVertical,));
    tileChildren.add(Card(
      child: IconButton(
        onPressed: () {
          addColumn(databaseTable);
        },
        icon: Constants.addColumnIcon)
    ));
    tileChildren.add(const SizedBox(height: Constants.spacingVertical,));

    return tileChildren;
  }

  Theme buildColumnOperationDropdownButton(DatabaseColumn column) {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: AppTheme.white
      ),
      child: DropdownButton(
        value: column.columnOperation,
        onChanged: (value) {
          changeColumnOperation(column, value!);
        },
        items: const [
          DropdownMenuItem(
            value: ColumnOperations.none,
            child: Text('Operation'),
          ),
          DropdownMenuItem(
            value: ColumnOperations.add,
            child: Text('ADD'),
          ),
          DropdownMenuItem(
            value: ColumnOperations.remove,
            child: Text('REMOVE'),
          ),
          DropdownMenuItem(
            value: ColumnOperations.modify,
            child: Text('MODIFY'),
          ),
        ],
      ),
    );
  }

  Theme buildDataTypesDropdownButton(DatabaseColumn column) { 
    return Theme(
       data: Theme.of(context).copyWith(
        canvasColor: AppTheme.white
      ),
      child: DropdownButton(
        value: column.dataType,
        onChanged: (value) {
          changeColumnDataType(column, value!);
        },
        items: const [
          DropdownMenuItem(
            value: DataTypes.none,
            child: Text('Data Type'),
          ),
          DropdownMenuItem(
            value: DataTypes.varchar,
            child: Text('VARCHAR'),
          ),
          DropdownMenuItem(
            value: DataTypes.number,
            child: Text('NUMBER'),
          ),
        ],
      ),
    );
  }

  List<Widget> buildCustomizedColumn(DatabaseColumn column) {
    switch (column.columnOperation) {
      case ColumnOperations.modify:
        return [
          TextFormField(
            initialValue: column.name ?? '',
            onChanged: (value) => updateColumnName(column, value),
            decoration: const InputDecoration(
              label: Text(Constants.columnNameLabel),
              hintText: Constants.columnNameHint,
            ),
          ),
          const SizedBox(height: Constants.spacingVertical,),
          TextFormField(
            initialValue: column.newName ?? '',
            onChanged: (value) => updateNewColumnName(column, value),
            decoration: const InputDecoration(
              label: Text(Constants.columnNewNameLabel),
              hintText: Constants.columnNewNameHint,
            ),
          ),
          const SizedBox(height: Constants.spacingVertical,),
          buildDataTypesDropdownButton(column),
        ];
      case ColumnOperations.add:
        return [
          TextFormField(
            initialValue: column.name ?? '',
            onChanged: (value) => updateColumnName(column, value),
            decoration: const InputDecoration(
              label: Text(Constants.columnNameLabel),
              hintText: Constants.columnNameHint,
            ),
          ),
          const SizedBox(height: Constants.spacingVertical,),
          buildDataTypesDropdownButton(column),
          const SizedBox(height: Constants.spacingVertical,),
          column.dataType != DataTypes.none ? TextFormField(
            initialValue: column.value ?? '',
            onChanged: (value) => updateColumnValue(column, value),
            decoration: const InputDecoration(
              label: Text(Constants.columnValueLabel),
              hintText: Constants.columnValueHint,
            ),
          ) : const SizedBox()
        ];
      case ColumnOperations.remove:
        return [
          TextFormField(
            initialValue: column.name ?? '',
            onChanged: (value) => updateColumnName(column, value),
            decoration: const InputDecoration(
              label: Text(Constants.columnNameLabel),
              hintText: Constants.columnNameHint,
            ),
          )
        ];
      default: return [];
    }
  }
}