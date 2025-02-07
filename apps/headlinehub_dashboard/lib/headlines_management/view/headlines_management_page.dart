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
    return BlocListener<HeadlinesManagementBloc, HeadlinesManagementState>(
      listenWhen: (previous, current) =>
          previous.deleteStatus != current.deleteStatus,
      listener: (context, state) {
        if (state.deleteStatus == HeadlinesManagementStatus.success) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Headline deleted'),
              duration: const Duration(seconds: 5),
              action: SnackBarAction(
                label: 'Undo',
                onPressed: () {
                  context
                      .read<HeadlinesManagementBloc>()
                      .add(const HeadlineUndoDeleteRequested());
                },
              ),
            ),
          );
        } else if (state.deleteStatus == HeadlinesManagementStatus.failure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to delete headline'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 2),
            ),
          );
        }
      },
      child: Column(
        children: [
          Expanded(
            child: _HeadlineTable(headlines: headlines),
          ),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: _Pagination(),
          ),
        ],
      ),
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
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            child: DataTable(
              showBottomBorder: true,
              sortColumnIndex: state.sortBy.index,
              sortAscending: state.sortDirection == SortDirection.ascending,
              columns: [
                DataColumn(
                  label: Container(
                    width: 200,
                    child: const Text('Title'),
                  ),
                  tooltip: 'Sort by title',
                  onSort: (columnIndex, ascending) =>
                      context.read<HeadlinesManagementBloc>().add(
                            HeadlinesSortRequested(
                              sortBy: HeadlineSortBy.title,
                              sortDirection:
                                  state.sortDirection == SortDirection.ascending
                                      ? SortDirection.descending
                                      : SortDirection.ascending,
                            ),
                          ),
                ),
                DataColumn(
                  label: Container(
                    width: 150,
                    child: const Text('Source'),
                  ),
                  tooltip: 'Sort by source',
                  onSort: (columnIndex, ascending) =>
                      context.read<HeadlinesManagementBloc>().add(
                            HeadlinesSortRequested(
                              sortBy: HeadlineSortBy.source,
                              sortDirection:
                                  state.sortDirection == SortDirection.ascending
                                      ? SortDirection.descending
                                      : SortDirection.ascending,
                            ),
                          ),
                ),
                DataColumn(
                  label: Container(
                    width: 120,
                    child: const Text('Category'),
                  ),
                  tooltip: 'Sort by category',
                  onSort: (columnIndex, ascending) =>
                      context.read<HeadlinesManagementBloc>().add(
                            HeadlinesSortRequested(
                              sortBy: HeadlineSortBy.category,
                              sortDirection:
                                  state.sortDirection == SortDirection.ascending
                                      ? SortDirection.descending
                                      : SortDirection.ascending,
                            ),
                          ),
                ),
                DataColumn(
                  label: Container(
                    width: 120,
                    child: const Text('Published'),
                  ),
                  tooltip: 'Sort by publication date',
                  onSort: (columnIndex, ascending) =>
                      context.read<HeadlinesManagementBloc>().add(
                            HeadlinesSortRequested(
                              sortBy: HeadlineSortBy.publishedAt,
                              sortDirection:
                                  state.sortDirection == SortDirection.ascending
                                      ? SortDirection.descending
                                      : SortDirection.ascending,
                            ),
                          ),
                ),
                DataColumn(
                  label: Container(
                    width: 100,
                    child: const Text('Status'),
                  ),
                  tooltip: 'Sort by status',
                  onSort: (columnIndex, ascending) =>
                      context.read<HeadlinesManagementBloc>().add(
                            HeadlinesSortRequested(
                              sortBy: HeadlineSortBy.status,
                              sortDirection:
                                  state.sortDirection == SortDirection.ascending
                                      ? SortDirection.descending
                                      : SortDirection.ascending,
                            ),
                          ),
                ),
                DataColumn(
                  label: Container(
                    width: 120,
                    child: const Text('Actions'),
                  ),
                ),
              ],
              rows: headlines.map((headline) {
                return DataRow(
                  cells: [
                    DataCell(
                      Container(
                        width: 200,
                        child: Text(
                          headline.title,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        width: 150,
                        child: Text(
                          headline.publishedBy.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        width: 120,
                        child: Text(
                          headline.category.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        width: 120,
                        child: Tooltip(
                          message: headline.publishedAt.toIso8601String(),
                          child: Text(
                            '${headline.publishedAt.day}/${headline.publishedAt.month}/${headline.publishedAt.year}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        width: 100,
                        child: Text(
                          headline.isActive ? 'Published' : 'Draft',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    DataCell(
                      Container(
                        width: 120,
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () async {
                                final result =
                                    await Navigator.of(context).push<bool>(
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
                                showDialog(
                                  context: context,
                                  builder: (dialogContext) => AlertDialog(
                                    title: const Text('Delete Headline'),
                                    content: const Text(
                                      'Are you sure you want to delete this headline?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.of(dialogContext).pop(),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(dialogContext).pop();
                                          context
                                              .read<HeadlinesManagementBloc>()
                                              .add(HeadlineDeleteRequested(
                                                  headline.id));
                                        },
                                        style: TextButton.styleFrom(
                                          foregroundColor: Colors.red,
                                        ),
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  ),
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
          ),
        );
      },
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
          items: [10, 20, 40]
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
