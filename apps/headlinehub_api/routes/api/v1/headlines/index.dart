import 'dart:async';
import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:headlinehub_models/headlinehub_models.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _handleGetHeadlines(context);
    // ignore: no_default_cases
    default:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _handleGetHeadlines(RequestContext context) async {
  // Get query parameters for pagination
  final params = context.request.uri.queryParameters;
  final page = int.tryParse(params['page'] ?? '1') ?? 1;
  final perPage = int.tryParse(params['perPage'] ?? '20') ?? 20;

  // Mock headline for demonstration
  final headlines = [
    Headline(
      id: '1',
      title: 'Sample Headline',
      content: 'This is a sample headline content.',
      publishedBy: 'HeadlineHub',
      publishedIn: 'https://example.com/image.jpg',
      publishedAt: DateTime.now(),
      category: HeadlineCategory.technology,
    ),
  ];

  // Create response with pagination
  final response = PaginatedResponse(
    items: headlines,
    total: headlines.length,
    page: page,
    perPage: perPage,
    message: 'Headlines fetched successfully',
  );

  return Response.json(
    body: response.toJson(),
  );
}
