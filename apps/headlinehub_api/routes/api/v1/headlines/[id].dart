import 'dart:async';
import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:in_memory_headlines_client/in_memory_headlines_client.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  switch (context.request.method) {
    case HttpMethod.get:
      return _handleGetHeadline(context, id);
    case HttpMethod.put:
      return _handleUpdateHeadline(context, id);
    case HttpMethod.delete:
      return _handleDeleteHeadline(context, id);
    // ignore: no_default_cases
    default:
      return Response(statusCode: HttpStatus.methodNotAllowed);
  }
}

Future<Response> _handleGetHeadline(RequestContext context, String id) async {
  final client = context.read<InMemoryHeadlinesClient>();

  try {
    final headline = await client.getHeadline(id);
    if (headline == null) {
      return Response.json(
        statusCode: HttpStatus.notFound,
        body: {'error': 'Headline not found'},
      );
    }

    return Response.json(body: headline.toJson());
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': 'An unexpected error occurred'},
    );
  }
}

Future<Response> _handleUpdateHeadline(
    RequestContext context, String id) async {
  final client = context.read<InMemoryHeadlinesClient>();

  try {
    final body = await context.request.json() as Map<String, dynamic>;
    final headline = Headline.fromJson(body);
    if (headline.id != id) {
      return Response.json(
        statusCode: HttpStatus.badRequest,
        body: {'error': 'Headline ID mismatch'},
      );
    }

    final updatedHeadline = await client.updateHeadline(headline);
    return Response.json(body: updatedHeadline.toJson());
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': 'An unexpected error occurred'},
    );
  }
}

Future<Response> _handleDeleteHeadline(
    RequestContext context, String id) async {
  final client = context.read<InMemoryHeadlinesClient>();

  try {
    await client.deleteHeadline(id);
    return Response(statusCode: HttpStatus.noContent);
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': 'An unexpected error occurred'},
    );
  }
}
