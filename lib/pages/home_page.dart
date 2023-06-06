import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../dialogs/dialog_builder.dart';
import '../models/database_table.dart';
import '../models/database_column.dart';
import '../models/column_operations.dart';

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
      table.columns.add(DatabaseColumn(name: 'New Column'));
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
            children: buildExpansionTileChildren(context, t),
          ),
        );
      },
    );
  }

  List<Card> buildExpansionTileChildren(BuildContext context, DatabaseTable databaseTable) {
    final List<Card> tileChildren = databaseTable.columns.map(
      (column) => Card(
        child: ListTile(
          title: Text(column.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildColumnOperationDropdownButton(context, column),
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

  DropdownButton buildColumnOperationDropdownButton(BuildContext context, DatabaseColumn column) {
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
}