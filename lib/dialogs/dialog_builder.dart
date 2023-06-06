import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../models/database_table.dart';

class DialogBuilder {
  DialogBuilder._();

  static AlertDialog addTableDialog(
    BuildContext context,
    GlobalKey<FormState> formKey,
    TextEditingController textEditingController,
  ) => AlertDialog(
    title: const Text(Constants.addTableTitle),
    actions: [
      ElevatedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: const Text('Cancel'),
      ),
      ElevatedButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            final newTable = DatabaseTable(name: textEditingController.value.text);
            Navigator.of(context).pop(newTable);
          }
        },
        child: const Text('Add'),
      ),
    ],
    content: Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: textEditingController,
            decoration: const InputDecoration(
              hintText: Constants.tableHintText,
              label: Text(Constants.tableLabel),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'You must enter a table name';
              } else if(value.contains(' ')) {
                return 'Table names cannot contain spaces';
              }
              return null;
            },
          ),
        ],
      ),
    ),
  );
}