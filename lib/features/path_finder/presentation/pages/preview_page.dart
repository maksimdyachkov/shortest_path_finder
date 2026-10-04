import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/path_result.dart';
import '../widgets/app_page.dart';
import '../widgets/path_grid.dart';

class PreviewPage extends StatelessWidget {
  const PreviewPage({super.key, required this.result});

  final PathResult result;

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: AppStrings.previewTitle,
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Flexible(
            flex: AppSizes.previewGridFlex,
            child: PathGrid(result: result),
          ),
          // A long path scrolls instead of pushing the grid off the screen.
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSizes.s8),
              child: Text(result.path, textAlign: TextAlign.center),
            ),
          ),
        ],
      ),
    );
  }
}
