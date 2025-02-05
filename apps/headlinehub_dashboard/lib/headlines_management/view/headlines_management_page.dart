// ignore_for_file: avoid_redundant_argument_values

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:headlinehub_dashboard/headlines_management/bloc/headlines_management_bloc.dart';
import 'package:headlinehub_dashboard/headlines_management/view/headline_creation_page.dart';
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
          _AddHeadlineButton(),
        ],
      ),
      body: BlocListener<HeadlinesManagementBloc, HeadlinesManagementState>(
        listener: (context, state) {
          if (state.createStatus == HeadlinesManagementStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Headline created successfully',
                ),
              ),
            );
          }

          if (state.createStatus == HeadlinesManagementStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Headline creation failed ',
                ),
              ),
            );
          }
          if (state.updateStatus == HeadlinesManagementStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Headline updated successfully',
                ),
              ),
            );
          }

          if (state.updateStatus == HeadlinesManagementStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Headline update failed ',
                ),
              ),
            );
          }
        },
        child: BlocBuilder<HeadlinesManagementBloc, HeadlinesManagementState>(
          builder: (context, state) {
            if (state.fetchStatus == HeadlinesManagementStatus.loading) {
              return const _LoadingView();
            } else if (state.fetchStatus == HeadlinesManagementStatus.failure) {
              return const _FailureView();
            } else if (state.fetchStatus == HeadlinesManagementStatus.success) {
              return const _SuccessView();
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
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
  const _SuccessView();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final availableHeight = constraints.maxHeight;
        const paginationHeight = 60.0; // Approximate height of pagination
        final tableHeight = availableHeight - paginationHeight;

        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: tableHeight,
                child: _HeadlineTable(),
              ),
            ),
            SliverToBoxAdapter(child: _Pagination()),
          ],
        );
      },
    );
  }
}

/// A search bar for filtering headlines.
class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextField(
        decoration: const InputDecoration(
          hintText: 'Search...',
          border: OutlineInputBorder(),
          suffixIcon: Icon(Icons.search),
        ),
        onChanged: (query) {
          context
              .read<HeadlinesManagementBloc>()
              .add(HeadlinesFetchByQueryRequested(query));
        },
      ),
    );
  }
}

/// Filters for the headlines management page.
class _Filters extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          _DropdownFilter(
            label: 'Source',
            items: const ['Source A', 'Source B', 'Source C'],
            onChanged: (value) {
              // Handle source filter change
            },
          ),
          _DropdownFilter(
            label: 'Category',
            items: HeadlineCategory.values.map((e) => e.name).toList(),
            onChanged: (value) {
              context.read<HeadlinesManagementBloc>().add(
                    HeadlinesFetchByCategoryRequested(
                      HeadlineCategory.values.firstWhere(
                        (e) => e.name == value,
                      ),
                    ),
                  );
            },
          ),
          _DropdownFilter(
            label: 'Status',
            items: const ['Published', 'Draft'],
            onChanged: (value) {
              // Handle status filter change
            },
          ),
          _DatePickerFilter(
            label: 'Date',
            onChanged: (startDate, endDate) {
              context.read<HeadlinesManagementBloc>().add(
                    HeadlinesFetchByDateRangeRequested(startDate, endDate),
                  );
            },
          ),
        ],
      ),
    );
  }
}

/// A dropdown filter widget.
class _DropdownFilter extends StatelessWidget {
  const _DropdownFilter({
    required this.label,
    required this.items,
    required this.onChanged,
  });

  final String label;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
          ),
          items: items
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

/// A date picker filter widget.
class _DatePickerFilter extends StatelessWidget {
  const _DatePickerFilter({
    required this.label,
    required this.onChanged,
  });

  final String label;
  final void Function(DateTime startDate, DateTime endDate) onChanged;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          onPressed: () async {
            final dateRange = await showDateRangePicker(
              context: context,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (dateRange != null) {
              onChanged(dateRange.start, dateRange.end);
            }
          },
          child: Text(label),
        ),
      ),
    );
  }
}

/// A table that displays the headlines.
class _HeadlineTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final state = context.read<HeadlinesManagementBloc>().state;
    return LayoutBuilder(
      builder: (context, constraints) {
        const middleColumnWidthWidth = 80.0;
        var edgeColumnWidth =
            (constraints.maxWidth - (middleColumnWidthWidth * 4)) / 2;
        final isMobile = constraints.maxWidth < 600;

        if (isMobile) {
          edgeColumnWidth = constraints.maxWidth / 2;
        }
        return SingleChildScrollView(
          child: DataTable(
            columns: [
              DataColumn(
                label: SizedBox(
                  width: edgeColumnWidth,
                  child: const Text(
                    'Title',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              if (!isMobile)
                const DataColumn(
                  label: SizedBox(
                    width: middleColumnWidthWidth,
                    child: Text(
                      'Source',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              if (!isMobile)
                const DataColumn(
                  label: SizedBox(
                    width: middleColumnWidthWidth,
                    child: Text(
                      'Category',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              if (!isMobile)
                const DataColumn(
                  label: SizedBox(
                    width: middleColumnWidthWidth,
                    child: Text(
                      'Published At',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              if (!isMobile)
                const DataColumn(
                  label: SizedBox(
                    width: middleColumnWidthWidth,
                    child: Text(
                      'Status',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              DataColumn(
                label: SizedBox(
                  width: edgeColumnWidth,
                  child: const Text(
                    'Actions',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
            rows: state.headlines.map((headline) {
              return DataRow(
                cells: [
                  DataCell(
                    SizedBox(
                      width: edgeColumnWidth,
                      child: Text(
                        headline.title,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  if (!isMobile)
                    DataCell(
                      SizedBox(
                        width: middleColumnWidthWidth,
                        child: Text(
                          headline.publishedBy.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  if (!isMobile)
                    DataCell(
                      SizedBox(
                        width: middleColumnWidthWidth,
                        child: Text(
                          headline.category.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  if (!isMobile)
                    DataCell(
                      SizedBox(
                        width: middleColumnWidthWidth,
                        child: Text(
                          headline.publishedAt.toIso8601String(),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  if (!isMobile)
                    DataCell(
                      SizedBox(
                        width: middleColumnWidthWidth,
                        child: Text(
                          headline.isActive ? 'Published' : 'Draft',
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  DataCell(
                    SizedBox(
                      width: edgeColumnWidth,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute<bool>(
                                builder: (context) => HeadlineUpdatePage(
                                  headline: headline,
                                ),
                              ),
                            ),
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
              context
                  .read<HeadlinesManagementBloc>()
                  .add(HeadlinesPerPageUpdated(value));
            }
          },
        );
      },
    );
  }
}

/// Button for adding a new headline.
class _AddHeadlineButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context).push(
            // ignore: inference_failure_on_instance_creation
            MaterialPageRoute(
              builder: (context) => const HeadlineCreationPage(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Headline'),
      ),
    );
  }
}
