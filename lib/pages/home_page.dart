import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../dialogs/dialog_builder.dart';
import '../models/database_table.dart';
import '../models/database_column.dart';
import '../models/column_operations.dart';
import '../models/data_types.dart';

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
    DatabaseTable(name: 'Missions'),
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
      appBar: buildAppBar(),
      floatingActionButton: buildFloatingActionButton(),
      body: buildListView(context),
    );
  }

  AppBar buildAppBar() => AppBar(
    title: const Text(Constants.appName),
  );

  FloatingActionButton buildFloatingActionButton() => FloatingActionButton(
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
    child: Constants.addTableIcon,
  );

  Widget buildListView(BuildContext context) {
    final itemCount = tables.length;

    if (itemCount == 0) {
      return const Center(
        child: Text(Constants.emptyTablesText),
      );
    }
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        final t = tables[index];
        return Card(
          child: ExpansionTile(
            leading: Constants.tableIcon,
            title: Text(t.tableName),
            children: buildExpansionTileChildren(t),
          ),
        );
      },
    );
  }

  List<Card> buildExpansionTileChildren(DatabaseTable databaseTable) {
    final List<Card> tileChildren = databaseTable.columns.map(
      (column) => Card(
        child: ListTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildColumnOperationDropdownButton(column),
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
      )
    ).toList();

    tileChildren.add(Card(
      child: IconButton(
        onPressed: () {
          addColumn(databaseTable);
        },
        icon: Constants.addColumnIcon)
    ));

    return tileChildren;
  }

  DropdownButton buildColumnOperationDropdownButton(DatabaseColumn column) {
    return DropdownButton(
      value: column.columnOperation,
      onChanged: (value) {
        changeColumnOperation(column, value);
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
    );
  }

  DropdownButton buildDataTypesDropdownButton(DatabaseColumn column) { 
    return DropdownButton(
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
    );
  }

  List<Widget> buildCustomizedColumn(DatabaseColumn column) {
    switch (column.columnOperation) {
      case ColumnOperations.modify:
        return [
          TextField(
            onChanged: (value) => updateColumnName(column, value),
            decoration: const InputDecoration(
              label: Text(Constants.columnNameLabel),
              hintText: Constants.columnNameHint,
            ),
          ),
          TextField(
            onChanged: (value) => updateNewColumnName(column, value),
            decoration: const InputDecoration(
              label: Text(Constants.columnNewNameLabel),
              hintText: Constants.columnNewNameHint,
            ),
          ),
          buildDataTypesDropdownButton(column),
          column.dataType != DataTypes.none ? TextField(
            onChanged: (value) => updateColumnValue(column, value),
            decoration: const InputDecoration(
              label: Text(Constants.columnValueLabel),
              hintText: Constants.columnValueHint,
            ),
          ) : const SizedBox()
        ];
      case ColumnOperations.add:
        return [
          TextField(
            onChanged: (value) => updateColumnName(column, value),
            decoration: const InputDecoration(
              label: Text(Constants.columnNameLabel),
              hintText: Constants.columnNameHint,
            ),
          ),
          buildDataTypesDropdownButton(column),
        ];
      case ColumnOperations.remove:
        return [
          TextField(
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