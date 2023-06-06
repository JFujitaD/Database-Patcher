import 'package:flutter/material.dart';

import '../components/app_bar_builder.dart';
import '../utils/constants.dart';

class ScriptPage extends StatelessWidget {
  final String script;

  const ScriptPage({required this.script, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBuilder.buildAppBar(),
      body: Center(
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(Constants.cardPadding),
            child: Expanded(child: Text(script)),
          ),
        ),
      ),
    );
  }
}