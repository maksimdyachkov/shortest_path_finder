import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/injector.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../domain/entities/path_result.dart';
import '../cubit/process_cubit.dart';
import '../cubit/process_state.dart';
import '../widgets/app_page.dart';
import '../widgets/primary_button.dart';
import 'result_list_page.dart';

class ProcessPage extends StatelessWidget {
  const ProcessPage({super.key});

  void _openResultList(BuildContext context, List<PathResult> results) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => ResultListPage(results: results)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProcessCubit>()..start(),
      child: AppPage(
        title: AppStrings.processTitle,
        child: BlocConsumer<ProcessCubit, ProcessState>(
          listener: (context, state) {
            if (state is ProcessSent) {
              _openResultList(context, state.results);
            }
          },
          builder: (context, state) => Column(
            children: [
              Expanded(child: _ProcessStatus(state: state)),
              if (state is ProcessCalculated) _SendSection(state: state),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProcessStatus extends StatelessWidget {
  const _ProcessStatus({required this.state});

  final ProcessState state;

  @override
  Widget build(BuildContext context) {
    final state = this.state;

    return switch (state) {
      ProcessLoadFailure() => Center(child: _ErrorText(state.message)),
      ProcessLoading() => _Progress(
        message: AppStrings.processLoading,
        percent: state.percent,
        isBusy: true,
      ),
      ProcessCalculating() => _Progress(
        message: AppStrings.processCalculating,
        percent: state.percent,
      ),
      ProcessCalculated() => _Progress(
        message: AppStrings.processFinished,
        percent: state.percent,
        isBusy: state is ProcessSending,
      ),
    };
  }
}

class _Progress extends StatelessWidget {
  const _Progress({
    required this.message,
    required this.percent,
    this.isBusy = false,
  });

  final String message;
  final int percent;

  /// Shows an endless loader instead of the calculated share.
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(message, textAlign: TextAlign.center),
        const SizedBox(height: AppSizes.s16),
        Text(
          AppStrings.percent(percent),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const Divider(),
        const SizedBox(height: AppSizes.s8),
        SizedBox.square(
          dimension: AppSizes.progressSize,
          child: CircularProgressIndicator(
            value: isBusy ? null : percent / ProcessState.maxPercent,
          ),
        ),
      ],
    );
  }
}

class _SendSection extends StatelessWidget {
  const _SendSection({required this.state});

  final ProcessCalculated state;

  @override
  Widget build(BuildContext context) {
    final state = this.state;
    final errorMessage = state is ProcessReady ? state.errorMessage : null;

    return Column(
      children: [
        if (errorMessage != null) ...[
          _ErrorText(errorMessage),
          const SizedBox(height: AppSizes.s16),
        ],
        PrimaryButton(
          label: AppStrings.processSendButton,
          onPressed: state is ProcessSending
              ? null
              : context.read<ProcessCubit>().sendResults,
        ),
      ],
    );
  }
}

class _ErrorText extends StatelessWidget {
  const _ErrorText(this.message);

  final String message;

  @override
  Widget build(BuildContext context) {
    return Text(
      message,
      textAlign: TextAlign.center,
      style: const TextStyle(color: AppColors.error),
    );
  }
}
