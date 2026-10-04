import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/path_result.dart';
import '../widgets/app_page.dart';
import 'preview_page.dart';

class ResultListPage extends StatelessWidget {
  const ResultListPage({super.key, required this.results});

  final List<PathResult> results;

  void _openPreview(BuildContext context, PathResult result) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => PreviewPage(result: result)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppPage(
      title: AppStrings.resultListTitle,
      padding: EdgeInsets.zero,
      child: ListView.separated(
        itemCount: results.length,
        separatorBuilder: (_, _) =>
            const Divider(height: AppSizes.dividerHeight),
        itemBuilder: (context, index) {
          final result = results[index];

          return InkWell(
            onTap: () => _openPreview(context, result),
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.s24),
              child: Text(result.path, textAlign: TextAlign.center),
            ),
          );
        },
      ),
    );
  }
}
