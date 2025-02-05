import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:headlinehub_app/headlines_feed/bloc/headlines_feed_bloc.dart';
import 'package:headlines_repository/headlines_repository.dart';

/// A page that displays a feed of headlines.
class HeadlinesFeedPage extends StatelessWidget {
  const HeadlinesFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final headlinesRepository =
        RepositoryProvider.of<HeadlinesRepository>(context);
    return BlocProvider(
      create: (context) => HeadlinesFeedBloc(headlinesRepository)
        ..add(const HeadlinesFetchRequested(limit: 10)),
      child: const _HeadlinesFeedView(),
    );
  }
}

/// A view that displays the headlines feed.
class _HeadlinesFeedView extends StatelessWidget {
  const _HeadlinesFeedView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Headlines')),
      body: BlocBuilder<HeadlinesFeedBloc, HeadlinesFeedState>(
        builder: (context, state) {
          if (state.status == HeadlinesFeedStatus.initial) {
            return const _LoadingView();
          } else if (state.status == HeadlinesFeedStatus.success ||
              state.status == HeadlinesFeedStatus.loading) {
            return _SuccessView(
              headlines: state.headlines,
              hasNextPage: state.hasNextPage,
              isLoading: state.status == HeadlinesFeedStatus.loading,
            );
          } else {
            return const _FailureView();
          }
        },
      ),
    );
  }
}

/// A view that displays a loading indicator.
class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}

/// A view that displays the headlines in a list with infinite scrolling.
class _SuccessView extends StatefulWidget {
  const _SuccessView({
    required this.headlines,
    required this.hasNextPage,
    this.isLoading = false,
  });

  final List<Headline> headlines;
  final bool hasNextPage;
  final bool isLoading;

  @override
  State<_SuccessView> createState() => _SuccessViewState();
}

class _SuccessViewState extends State<_SuccessView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom && widget.hasNextPage && !widget.isLoading) {
      context
          .read<HeadlinesFeedBloc>()
          .add(const HeadlinesFetchRequested(limit: 10));
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.8);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final headline = widget.headlines[index];
              return ListTile(
                title: Text(headline.title),
                subtitle: Text(headline.publishedBy.name),
              );
            },
            childCount: widget.headlines.length,
          ),
        ),
        if (widget.hasNextPage || widget.isLoading)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }
}

/// A view that displays an error message.
class _FailureView extends StatelessWidget {
  const _FailureView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Failed to fetch headlines'));
  }
}
