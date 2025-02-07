import 'dart:async';
import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:in_memory_headlines_client/in_memory_headlines_client.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _handleGetHeadlines(context);
    case HttpMethod.post:
      return _handleCreateHeadline(context);
    // ignore: no_default_cases
    default:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _handleGetHeadlines(RequestContext context) async {
  final client = context.read<InMemoryHeadlinesClient>();

  try {
    // Parse query parameters
    final params = context.request.uri.queryParameters;
    final options = HeadlineQueryOptions(
      page: int.tryParse(params['page'] ?? '1') ?? 1,
      limit: int.tryParse(params['limit'] ?? '20') ?? 20,
      searchQuery: params['query'],
      category: params['category'] != null
          ? HeadlineCategory.values.firstWhere(
              (e) => e.name == params['category'],
              orElse: () => HeadlineCategory.general,
            )
          : null,
      status: params['status'] != null
          ? HeadlineStatus.values.firstWhere(
              (e) => e.name == params['status'],
              orElse: () => HeadlineStatus.draft,
            )
          : null,
      dateRange: params['startDate'] != null && params['endDate'] != null
          ? DateTimeRange(
              start: DateTime.parse(params['startDate']!),
              end: DateTime.parse(params['endDate']!),
            )
          : null,
      sortBy: params['sortBy'] != null
          ? HeadlineSortBy.values.firstWhere(
              (e) => e.name == params['sortBy'],
              orElse: () => HeadlineSortBy.publishedAt,
            )
          : HeadlineSortBy.publishedAt,
      sortDirection: params['sortDirection'] == 'ascending'
          ? SortDirection.ascending
          : SortDirection.descending,
    );

    final response = await client.getHeadlines(options);
    return Response.json(
      body: response.toJson((headline) => headline.toJson()),
    );
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': 'An unexpected error occurred'},
    );
  }
}

Future<Response> _handleCreateHeadline(RequestContext context) async {
  final client = context.read<InMemoryHeadlinesClient>();

  try {
    final body = await context.request.json() as Map<String, dynamic>;
    final headline = Headline.fromJson(body);
    final createdHeadline = await client.createHeadline(headline);

    return Response.json(
      statusCode: HttpStatus.created,
      body: createdHeadline.toJson(),
    );
  } on HeadlineCreationException catch (e) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': e.message},
    );
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': 'An unexpected error occurred'},
    );
  }
}
