import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:headlinehub_app/app/bloc/app_bloc.dart';
import 'package:headlinehub_app/headlines_feed/view/headlines_feed_page.dart';
import 'package:headlinehub_app/l10n/l10n.dart';
import 'package:headlines_repository/headlines_repository.dart';

class App extends StatelessWidget {
  const App({
    required this.headlinesRepository,
    super.key,
  });

  final HeadlinesRepository headlinesRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: headlinesRepository,
        ),
      ],
      child: BlocProvider(
        create: (context) => AppBloc(),
        child: const _AppView(),
      ),
    );
  }
}

class _AppView extends StatelessWidget {
  const _AppView();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        useMaterial3: true,
      ),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const HeadlinesFeedPage(),
    );
  }
}
