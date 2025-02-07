// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter/material.dart' hide DateTimeRange;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:headlinehub_dashboard/headlines_management/bloc/headlines_management_bloc.dart';
import 'package:headlinehub_dashboard/headlines_management/view/headline_create_page.dart';
import 'package:headlinehub_dashboard/headlines_management/view/headline_update_page.dart';
import 'package:headlines_repository/headlines_repository.dart';
import 'package:intl/intl.dart' as intl;

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
        actions: const [
          _RefreshButton(),
          _SearchButton(),
          _FilterButton(),
        ],
      ),
      floatingActionButton: Padding(
        padding:
            const EdgeInsets.only(bottom: 80), // Add padding to avoid overlap
        child: FloatingActionButton(
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
          child: const Icon(Icons.add),
        ),
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
            child: Padding(
              padding: const EdgeInsets.all(16), // Add padding around table
              child: _HeadlineTable(headlines: headlines),
            ),
          ),
          Container(
            height: 64, // Fixed height for pagination
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
                            HeadlinesFetchRequested(
                              sortBy: HeadlineSortBy.title,
                              sortDirection: ascending
                                  ? SortDirection.ascending
                                  : SortDirection.descending,
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
                            HeadlinesFetchRequested(
                              sortBy: HeadlineSortBy.source,
                              sortDirection: ascending
                                  ? SortDirection.ascending
                                  : SortDirection.descending,
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
                            HeadlinesFetchRequested(
                              sortBy: HeadlineSortBy.category,
                              sortDirection: ascending
                                  ? SortDirection.ascending
                                  : SortDirection.descending,
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
                            HeadlinesFetchRequested(
                              sortBy: HeadlineSortBy.publishedAt,
                              sortDirection: ascending
                                  ? SortDirection.ascending
                                  : SortDirection.descending,
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
                            HeadlinesFetchRequested(
                              sortBy: HeadlineSortBy.status,
                              sortDirection: ascending
                                  ? SortDirection.ascending
                                  : SortDirection.descending,
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
                          headline.status.name,
                          style: TextStyle(
                            color: _getStatusColor(headline.status),
                          ),
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

Color _getStatusColor(HeadlineStatus status) {
  switch (status) {
    case HeadlineStatus.published:
      return Colors.green;
    case HeadlineStatus.draft:
      return Colors.grey;
    case HeadlineStatus.archived:
      return Colors.brown;
    case HeadlineStatus.pending:
      return Colors.orange;
  }
}

/// Pagination controls for the headlines management page.
class _Pagination extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HeadlinesManagementBloc, HeadlinesManagementState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Navigation buttons group
              Row(
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
                    child: const Text('Previous'),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '${state.currentPage} of ${state.totalPages}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(width: 16),
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
                ],
              ),
              // Items per page dropdown
              Row(
                children: [
                  Text(
                    'Show',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(width: 8),
                  _ItemsPerPageDropdown(),
                ],
              ),
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
        return SizedBox(
          width: 140, // Fixed width for consistency
          child: DropdownButtonFormField<int>(
            decoration: const InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            value: state.perPage,
            items: const [
              DropdownMenuItem(value: 10, child: Text('10 per page')),
              DropdownMenuItem(value: 25, child: Text('25 per page')),
              DropdownMenuItem(value: 50, child: Text('50 per page')),
            ],
            onChanged: (value) {
              if (value != null) {
                context.read<HeadlinesManagementBloc>().add(
                      HeadlinesFetchRequested(perPage: value),
                    );
              }
            },
          ),
        );
      },
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
        final searchController = TextEditingController();
        showDialog<dynamic>(
          context: context,
          builder: (dialogContext) => BlocProvider.value(
            value: context.read<HeadlinesManagementBloc>(),
            child: AlertDialog(
              title: const Text('Search Headlines'),
              content: TextField(
                controller: searchController,
                decoration: const InputDecoration(
                  labelText: 'Search',
                  hintText: 'Enter search terms...',
                ),
                onSubmitted: (value) {
                  context.read<HeadlinesManagementBloc>().add(
                        HeadlinesFetchRequested(searchQuery: value),
                      );
                  Navigator.pop(dialogContext);
                },
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    context.read<HeadlinesManagementBloc>().add(
                          HeadlinesFetchRequested(
                            searchQuery: searchController.text,
                          ),
                        );
                    Navigator.pop(dialogContext);
                  },
                  child: const Text('Search'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HeadlinesManagementBloc, HeadlinesManagementState>(
      builder: (context, state) {
        final hasActiveFilters = state.selectedCategory != null ||
            state.filterDateRange != null ||
            state.filterStatus != null ||
            state.searchQuery != null;

        return IconButton(
          icon: Badge(
            isLabelVisible: hasActiveFilters,
            child: const Icon(Icons.filter_list),
          ),
          tooltip: 'Filter headlines',
          onPressed: () => _showFilterDialog(context),
        );
      },
    );
  }

  void _showFilterDialog(BuildContext context) {
    // Get the bloc before showing dialog
    final bloc = context.read<HeadlinesManagementBloc>();

    showDialog(
      context: context,
      builder: (dialogContext) {
        // Provide the bloc to the dialog
        return BlocProvider.value(
          value: bloc,
          child: AlertDialog(
            title: const Text('Filter Headlines'),
            content: SizedBox(
              width: 400,
              child: SingleChildScrollView(
                child: BlocBuilder<HeadlinesManagementBloc,
                    HeadlinesManagementState>(
                  builder: (context, state) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildCategoryFilter(context, state),
                        const SizedBox(height: 16),
                        _buildStatusFilter(context, state),
                        const SizedBox(height: 16),
                        _buildDateRangeFilter(context, state),
                      ],
                    );
                  },
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  context.read<HeadlinesManagementBloc>().add(
                        HeadlinesFetchRequested(
                          category: bloc.state.selectedCategory,
                          dateRange: bloc.state.filterDateRange,
                          status: bloc.state.filterStatus,
                          searchQuery: bloc.state.searchQuery,
                        ),
                      );
                  Navigator.pop(context);
                },
                child: const Text('Apply'),
              ),
              TextButton(
                onPressed: () {
                  context.read<HeadlinesManagementBloc>().add(
                        const HeadlinesFetchRequested(
                          category: null,
                          dateRange: null,
                          status: null,
                          searchQuery: null,
                        ),
                      );
                  Navigator.pop(context);
                },
                child: const Text('Reset'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryFilter(
      BuildContext context, HeadlinesManagementState state) {
    return DropdownButtonFormField<HeadlineCategory?>(
      decoration: const InputDecoration(labelText: 'Category'),
      value: state.selectedCategory,
      items: [
        const DropdownMenuItem(value: null, child: Text('All Categories')),
        ...HeadlineCategory.values.map(
          (category) => DropdownMenuItem(
            value: category,
            child: Text(category.name),
          ),
        ),
      ],
      onChanged: (value) {
        context.read<HeadlinesManagementBloc>().add(
              HeadlinesFetchRequested(category: value),
            );
      },
    );
  }

  Widget _buildStatusFilter(
      BuildContext context, HeadlinesManagementState state) {
    return DropdownButtonFormField<HeadlineStatus?>(
      decoration: const InputDecoration(labelText: 'Status'),
      value: state.filterStatus,
      items: [
        const DropdownMenuItem(value: null, child: Text('All Statuses')),
        ...HeadlineStatus.values.map(
          (status) => DropdownMenuItem(
            value: status,
            child: Text(status.name),
          ),
        ),
      ],
      onChanged: (value) {
        context.read<HeadlinesManagementBloc>().add(
              HeadlinesFetchRequested(status: value),
            );
      },
    );
  }

  Widget _buildDateRangeFilter(
      BuildContext context, HeadlinesManagementState state) {
    final dateFormat = intl.DateFormat('dd/MM/yyyy');
    return Row(
      children: [
        Expanded(
          child: TextButton.icon(
            icon: const Icon(Icons.calendar_today),
            label: Text(
              state.filterDateRange?.start != null
                  ? dateFormat.format(state.filterDateRange!.start)
                  : 'Start Date',
            ),
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: state.filterDateRange?.start ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (date != null && context.mounted) {
                final endDate = state.filterDateRange?.end ??
                    date.add(const Duration(days: 30));
                context.read<HeadlinesManagementBloc>().add(
                      HeadlinesFetchRequested(
                        dateRange: DateTimeRange(start: date, end: endDate),
                      ),
                    );
              }
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextButton.icon(
            icon: const Icon(Icons.calendar_today),
            label: Text(
              state.filterDateRange?.end != null
                  ? dateFormat.format(state.filterDateRange!.end)
                  : 'End Date',
            ),
            onPressed: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: state.filterDateRange?.end ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime.now(),
              );
              if (date != null && context.mounted) {
                final startDate = state.filterDateRange?.start ??
                    date.subtract(const Duration(days: 30));
                context.read<HeadlinesManagementBloc>().add(
                      HeadlinesFetchRequested(
                        dateRange: DateTimeRange(start: startDate, end: date),
                      ),
                    );
              }
            },
          ),
        ),
      ],
    );
  }
}

class _RefreshButton extends StatelessWidget {
  const _RefreshButton();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.refresh),
      onPressed: () {
        context
            .read<HeadlinesManagementBloc>()
            .add(const HeadlinesFetchRequested());
      },
    );
  }
}
