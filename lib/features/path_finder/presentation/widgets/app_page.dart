import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';

/// The common frame of every screen: a titled app bar and a safe, padded body.
class AppPage extends StatelessWidget {
  const AppPage({
    super.key,
    required this.title,
    required this.child,
    this.padding = const EdgeInsets.all(AppSizes.s16),
  });

  final String title;
  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
