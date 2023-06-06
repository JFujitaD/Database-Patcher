import 'package:flutter/material.dart';

import '../utils/constants.dart';

class AppBarBuilder {
  AppBarBuilder._();

  static AppBar buildAppBar() => AppBar(
    title: const Text(Constants.appName),
  );
}