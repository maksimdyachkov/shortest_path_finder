import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/di/injector.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/app_page.dart';
import '../widgets/primary_button.dart';
import 'process_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeCubit>(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  late final _urlController = TextEditingController(
    text: context.read<HomeCubit>().state.url,
  );

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  void _openProcessPage() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const ProcessPage()));
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();

    return AppPage(
      title: AppStrings.homeTitle,
      child: BlocConsumer<HomeCubit, HomeState>(
        listenWhen: (_, current) => current is HomeSaved,
        listener: (_, _) => _openProcessPage(),
        builder: (context, state) {
          final errorText = switch (state) {
            HomeInvalidUrl() => AppStrings.homeInvalidUrl,
            HomeInitial() || HomeSaving() || HomeSaved() => null,
          };

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(AppStrings.homeDescription),
              const SizedBox(height: AppSizes.s16),
              Row(
                children: [
                  const Icon(Icons.compare_arrows, color: AppColors.icon),
                  const SizedBox(width: AppSizes.s24),
                  Expanded(
                    child: TextField(
                      controller: _urlController,
                      keyboardType: TextInputType.url,
                      autocorrect: false,
                      onChanged: cubit.urlChanged,
                      decoration: InputDecoration(errorText: errorText),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              PrimaryButton(
                label: AppStrings.homeStartButton,
                onPressed: state is HomeSaving ? null : cubit.submit,
              ),
            ],
          );
        },
      ),
    );
  }
}
