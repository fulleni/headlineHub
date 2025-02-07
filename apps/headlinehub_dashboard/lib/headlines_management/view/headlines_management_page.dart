// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:headlinehub_dashboard/headlines_management/bloc/headlines_management_bloc.dart';
import 'package:headlinehub_dashboard/headlines_management/view/headline_create_page.dart';
import 'package:headlinehub_dashboard/headlines_management/view/headline_update_page.dart';
import 'package:headlines_repository/headlines_repository.dart';

/// A page that enable managing headlines.
class HeadlinesManagementPage extends StatelessWidget {
  const HeadlinesManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final headlinesRepository =
        RepositoryProvider.of<HeadlinesRepository>(context);
    return BlocProvider(
      create: (context) => HeadlinesManagementBloc(headlinesRepository)
        ..add(const HeadlinesFetchRequested()),
      child: const _HeadlinesManagementView(),
    );
  }
}

/// A view that displays the headlines management page.
class _HeadlinesManagementView extends StatelessWidget {
  const _HeadlinesManagementView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Headlines'),
        actions: [
          const _SearchButton(),
          _AddHeadlineButton(),
        ],
      ),
      body: BlocBuilder<HeadlinesManagementBloc, HeadlinesManagementState>(
        builder: (context, state) {
          print('REBUILDING _HeadlinesManagementView');
          if (state.fetchStatus == HeadlinesManagementStatus.loading) {
            return const _LoadingView();
          } else if (state.fetchStatus == HeadlinesManagementStatus.failure) {
            return const _FailureView();
          } else if (state.fetchStatus == HeadlinesManagementStatus.success) {
            return _SuccessView(
              headlines: state.headlines,
            );
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

class _FailureView extends StatelessWidget {
  const _FailureView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Failed to fetch headlines'));
  }
}

class _SuccessView extends StatelessWidget {
  const _SuccessView({required this.headlines});

  final List<Headline> headlines;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: SizedBox(
            // height: tableHeight,
            child: _HeadlineTable(headlines: headlines),
          ),
        ),
        SliverToBoxAdapter(child: _Pagination()),
      ],
    );
  }
}

/// A table that displays the headlines.
class _HeadlineTable extends StatelessWidget {
  const _HeadlineTable({required this.headlines});

  final List<Headline> headlines;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HeadlinesManagementBloc, HeadlinesManagementState>(
      builder: (context, state) {
        return SingleChildScrollView(
          child: DataTable(
            showBottomBorder: true,
            sortColumnIndex: state.sortBy.index,
            sortAscending: state.sortDirection == SortDirection.ascending,
            columns: [
              DataColumn(
                label: const Text('Title'),
                onSort: (_, __) => _onSort(
                  context,
                  HeadlineSortBy.title,
                  state.sortBy == HeadlineSortBy.title &&
                          state.sortDirection == SortDirection.ascending
                      ? SortDirection.descending
                      : SortDirection.ascending,
                ),
              ),
              DataColumn(
                label: const Text('Source'),
                onSort: (_, __) => _onSort(
                  context,
                  HeadlineSortBy.source,
                  state.sortBy == HeadlineSortBy.source &&
                          state.sortDirection == SortDirection.ascending
                      ? SortDirection.descending
                      : SortDirection.ascending,
                ),
              ),
              DataColumn(
                label: const Text('Category'),
                onSort: (_, __) => _onSort(
                  context,
                  HeadlineSortBy.category,
                  state.sortBy == HeadlineSortBy.category &&
                          state.sortDirection == SortDirection.ascending
                      ? SortDirection.descending
                      : SortDirection.ascending,
                ),
              ),
              DataColumn(
                label: const Text('Published At'),
                onSort: (_, __) => _onSort(
                  context,
                  HeadlineSortBy.publishedAt,
                  state.sortBy == HeadlineSortBy.publishedAt &&
                          state.sortDirection == SortDirection.ascending
                      ? SortDirection.descending
                      : SortDirection.ascending,
                ),
              ),
              DataColumn(
                label: const Text('Status'),
                onSort: (_, __) => _onSort(
                  context,
                  HeadlineSortBy.status,
                  state.sortBy == HeadlineSortBy.status &&
                          state.sortDirection == SortDirection.ascending
                      ? SortDirection.descending
                      : SortDirection.ascending,
                ),
              ),
              const DataColumn(
                label: Text('Actions'),
              ),
            ],
            rows: headlines.map((headline) {
              return DataRow(
                cells: [
                  DataCell(
                    SizedBox(
                      child: Text(
                        headline.title,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      child: Text(
                        headline.publishedBy.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      child: Text(
                        headline.category.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      child: Text(
                        headline.publishedAt.toIso8601String(),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      child: Text(
                        headline.isActive ? 'Published' : 'Draft',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  DataCell(
                    SizedBox(
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () async {
                              final result = await Navigator.of(context).push<bool>(
                                MaterialPageRoute<bool>(
                                  builder: (context) => HeadlineUpdatePage(
                                    headline: headline,
                                  ),
                                ),
                              );
                              if (!context.mounted) return;
                              if (result == false) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    showCloseIcon: true,
                                    content: Text('Headline update failed'),
                                  ),
                                );
                              } else {
                                context
                                    .read<HeadlinesManagementBloc>()
                                    .add(const HeadlinesFetchRequested());
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              context.read<HeadlinesManagementBloc>().add(
                                    HeadlineDeleteRequested(headline.id),
                                  );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _onSort(
    BuildContext context,
    HeadlineSortBy sortBy,
    SortDirection direction,
  ) {
    context.read<HeadlinesManagementBloc>().add(
          HeadlinesSortRequested(
            sortBy: sortBy,
            sortDirection: direction,
          ),
        );
  }
}

/// Pagination controls for the headlines management page.
class _Pagination extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HeadlinesManagementBloc, HeadlinesManagementState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: state.currentPage > 1
                    ? () {
                        context.read<HeadlinesManagementBloc>().add(
                              HeadlinesFetchRequested(
                                page: state.currentPage - 1,
                              ),
                            );
                      }
                    : null,
                child: const Text('Prev'),
              ),
              Text('${state.currentPage} of ${state.totalPages}'),
              TextButton(
                onPressed: state.hasNextPage
                    ? () {
                        context.read<HeadlinesManagementBloc>().add(
                              HeadlinesFetchRequested(
                                page: state.currentPage + 1,
                              ),
                            );
                      }
                    : null,
                child: const Text('Next'),
              ),
              _ItemsPerPageDropdown(),
            ],
          ),
        );
      },
    );
  }
}

/// Dropdown for selecting the number of items per page.
class _ItemsPerPageDropdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HeadlinesManagementBloc, HeadlinesManagementState>(
      builder: (context, state) {
        return DropdownButton<int>(
          value: state.perPage,
          items: [5, 10, 20, 40]
              .map(
                (value) => DropdownMenuItem<int>(
                  value: value,
                  child: Text('$value items per page'),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) {
              context.read<HeadlinesManagementBloc>()
                ..add(HeadlinesPerPageUpdated(value))
                ..add(const HeadlinesFetchRequested());
            }
          },
        );
      },
    );
  }
}

class _AddHeadlineButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: IconButton(
        onPressed: () async {
          final result = await Navigator.of(context).push<bool>(
            MaterialPageRoute<bool>(
              builder: (context) => const HeadlineCreatePage(),
            ),
          );
          if (!context.mounted) return;
          if (result == false) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                showCloseIcon: true,
                content: Text('Headline creation failed'),
              ),
            );
          } else {
            context
                .read<HeadlinesManagementBloc>()
                .add(const HeadlinesFetchRequested());
          }
        },
        icon: const Icon(Icons.add),
      ),
    );
  }
}

class _SearchButton extends StatelessWidget {
  const _SearchButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.search),
      onPressed: () {
        showSearch(
          context: context,
          delegate: HeadlinesSearchDelegate(
            BlocProvider.of<HeadlinesManagementBloc>(context),
          ),
        );
      },
    );
  }
}

class HeadlinesSearchDelegate extends SearchDelegate<String> {
  HeadlinesSearchDelegate(this.bloc);

  final HeadlinesManagementBloc bloc;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    bloc.add(HeadlinesFetchByQueryRequested(query));
    return BlocBuilder<HeadlinesManagementBloc, HeadlinesManagementState>(
      bloc: bloc,
      builder: (context, state) {
        if (state.fetchStatus == HeadlinesManagementStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state.fetchStatus == HeadlinesManagementStatus.failure) {
          return const Center(child: Text('Failed to fetch headlines'));
        } else if (state.fetchStatus == HeadlinesManagementStatus.success) {
          return ListView.builder(
            itemCount: state.headlines.length,
            itemBuilder: (context, index) {
              final headline = state.headlines[index];
              return ListTile(
                title: Text(headline.title),
                subtitle: Text(headline.publishedBy.name),
                onTap: () {
                  close(context, headline.title);
                },
              );
            },
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
