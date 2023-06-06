import 'package:flutter/material.dart';

import '../components/app_bar_builder.dart';

class ScriptPage extends StatelessWidget {
  final String script;

  const ScriptPage({required this.script, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarBuilder.buildAppBar(),
      body: Card(
        child: Text(script),
      ),
    );
  }
}