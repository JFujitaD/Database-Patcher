import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../dialogs/dialog_builder.dart';
import '../models/database_table.dart';

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

  void updateTable(DatabaseTable newTable) {
    setState(() {
      tables.add(newTable);
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
      ).then((newTable) => updateTable(newTable));
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
      (column) => const Card(
        child: ListTile(
          title: Text('TEST'),
        ),
      )
    ).toList();

    tileChildren.add(const Card(
      child: Constants.addColumnIcon,
    ));

    return tileChildren;
  }
}