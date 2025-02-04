import 'dart:async';
import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:headlines_client/headlines_client.dart';
import 'package:in_memory_headlines_client/in_memory_headlines_client.dart';

Future<Response> onRequest(RequestContext context) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _handleGetHeadlines(context);
    case HttpMethod.post:
      return _handleCreateHeadline(context);
    case HttpMethod.put:
      return _handleUpdateHeadline(context);
    case HttpMethod.delete:
      return _handleDeleteHeadline(context);
    // ignore: no_default_cases
    default:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _handleGetHeadlines(RequestContext context) async {
  final client = context.read<InMemoryHeadlinesClient>();

  try {
    // Get query parameters for pagination and filtering
    final params = context.request.uri.queryParameters;
    final page = int.tryParse(params['page'] ?? '1') ?? 1;
    final limit = int.tryParse(params['limit'] ?? '20') ?? 20;
    final query = params['query'];
    final category = params['category'];
    final startDate = params['startDate'] != null
        ? DateTime.tryParse(params['startDate']!)
        : null;
    final endDate = params['endDate'] != null
        ? DateTime.tryParse(params['endDate']!)
        : null;

    final options = HeadlineQueryOptions(
      page: page,
      limit: limit,
      startDate: startDate,
      endDate: endDate,
    );

    PaginatedResponse<Headline> response;

    if (query != null) {
      response = await client.getHeadlinesByQuery(query, options);
    } else if (category != null) {
      response = await client.getHeadlinesByCategory(
        HeadlineCategory.values.firstWhere(
          (e) => e.name == category,
          orElse: () => HeadlineCategory.general,
        ),
        options,
      );
    } else if (startDate != null && endDate != null) {
      response =
          await client.getHeadlinesByDateRange(startDate, endDate, options);
    } else {
      response = await client.getHeadlines(options);
    }

    return Response.json(
      body: response.toJson((headline) => headline.toJson()),
    );
  } on HeadlineNotFoundException catch (e) {
    return Response.json(
      statusCode: HttpStatus.notFound,
      body: {'error': e.message},
    );
  } on HeadlineCategoryException catch (e) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': e.message},
    );
  } on HeadlineSearchingException catch (e) {
    return Response.json(
      statusCode: HttpStatus.badRequest,
      body: {'error': e.message},
    );
  } on HeadlineDateRangeException catch (e) {
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

Future<Response> _handleUpdateHeadline(RequestContext context) async {
  final client = context.read<InMemoryHeadlinesClient>();

  try {
    final body = await context.request.json() as Map<String, dynamic>;
    final headline = Headline.fromJson(body);
    final updatedHeadline = await client.updateHeadline(headline);

    return Response.json(
      body: updatedHeadline.toJson(),
    );
  } on HeadlineNotFoundException catch (e) {
    return Response.json(
      statusCode: HttpStatus.notFound,
      body: {'error': e.message},
    );
  } on HeadlineUpdateException catch (e) {
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

Future<Response> _handleDeleteHeadline(RequestContext context) async {
  final client = context.read<InMemoryHeadlinesClient>();

  try {
    final id = context.request.uri.queryParameters['id'];
    if (id == null) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {'error': 'ID is required'},
      );
    }

    await client.deleteHeadline(id);

    return Response(statusCode: HttpStatus.noContent);
  } on HeadlineNotFoundException catch (e) {
    return Response.json(
      statusCode: HttpStatus.notFound,
      body: {'error': e.message},
    );
  } on HeadlineDeletionException catch (e) {
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
