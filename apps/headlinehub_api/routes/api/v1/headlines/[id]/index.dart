import 'dart:async';
import 'dart:io';
import 'package:dart_frog/dart_frog.dart';
import 'package:in_memory_headlines_client/in_memory_headlines_client.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  if (context.request.method != HttpMethod.get) {
    return Response(statusCode: HttpStatus.methodNotAllowed);
  }

  final client = context.read<InMemoryHeadlinesClient>();

  try {
    final headline = await client.getHeadline(id);

    return Response.json(
      body: headline?.toJson(),
    );
  } on HeadlineNotFoundException catch (e) {
    return Response.json(
      statusCode: HttpStatus.notFound,
      body: {'error': e.message},
    );
  } catch (e) {
    return Response.json(
      statusCode: HttpStatus.internalServerError,
      body: {'error': 'An unexpected error occurred'},
    );
  }
}
