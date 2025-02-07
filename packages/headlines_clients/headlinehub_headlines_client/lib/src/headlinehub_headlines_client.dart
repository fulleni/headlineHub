// ignore_for_file: avoid_redundant_argument_values

import 'dart:convert';

import 'package:headlines_client/headlines_client.dart';
import 'package:http/http.dart' as http;

/// {@template headlinehub_headlines_client}
/// headlinHub API implementation of the [HeadlinesClient] abstract class
/// {@endtemplate}
class HeadlinehubHeadlinesClient extends HeadlinesClient {
  /// {@macro headlinehub_headlines_client}
  const HeadlinehubHeadlinesClient(this.baseUrl, this.httpClient);

  /// The base URL of the HeadlineHub API.
  final String baseUrl;

  /// The HTTP client used to make requests.
  final http.Client httpClient;

  String _buildQueryParams(HeadlineQueryOptions? options) {
    if (options == null) return '';

    final params = <String>[];

    if (options.page > 1) params.add('page=${options.page}');
    if (options.limit != 20) params.add('limit=${options.limit}');

    if (options.dateRange != null) {
      params.add('startDate=${options.dateRange!.start.toIso8601String()}');
      params.add('endDate=${options.dateRange!.end.toIso8601String()}');
    }

    if (options.status != null) {
      params.add('status=${options.status!.name}');
    }

    if (options.category != null) {
      params.add('category=${options.category!.name}');
    }

    if (options.searchQuery?.isNotEmpty ?? false) {
      params.add('query=${Uri.encodeComponent(options.searchQuery!)}');
    }

    params.add('sortBy=${options.sortBy.name}');
    params.add('sortDirection=${options.sortDirection.name}');

    return params.isEmpty ? '' : '?${params.join('&')}';
  }

  @override
  Future<PaginatedResponse<Headline>> getHeadlines([
    HeadlineQueryOptions? options,
  ]) async {
    try {
      final response = await httpClient.get(
        Uri.parse('$baseUrl/headlines${_buildQueryParams(options)}'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final headlines = (data['items'] as List)
            .map((json) => Headline.fromJson(json as Map<String, dynamic>))
            .toList();

        return PaginatedResponse<Headline>(
          items: headlines,
          currentPage: data['currentPage'] as int,
          totalPages: data['totalPages'] as int,
          totalItems: data['totalItems'] as int,
          hasNextPage: data['hasNextPage'] as bool,
          hasPreviousPage: data['hasPreviousPage'] as bool,
        );
      } else {
        throw const HeadlineSearchingException('Failed to fetch headlines');
      }
    } catch (e) {
      throw const HeadlineSearchingException('Failed to fetch headlines');
    }
  }

  @override
  Future<Headline?> getHeadline(String id) async {
    try {
      final response =
          await httpClient.get(Uri.parse('$baseUrl/headlines/$id'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return Headline.fromJson(data);
      } else if (response.statusCode == 404) {
        throw const HeadlineNotFoundException('Headline not found');
      } else {
        throw const HeadlineNotFoundException('Failed to fetch headline');
      }
    } catch (e) {
      throw const HeadlineNotFoundException('Failed to fetch headline');
    }
  }

  @override
  Future<Headline> createHeadline(Headline headline) async {
    try {
      final response = await httpClient.post(
        Uri.parse('$baseUrl/headlines'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(headline.toJson()),
      );
      if (response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return Headline.fromJson(data);
      } else {
        throw const HeadlineCreationException('Failed to create headline');
      }
    } catch (e) {
      throw const HeadlineCreationException('Failed to create headline');
    }
  }

  @override
  Future<Headline> updateHeadline(Headline headline) async {
    try {
      final response = await httpClient.put(
        Uri.parse('$baseUrl/headlines/${headline.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(headline.toJson()),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return Headline.fromJson(data);
      } else if (response.statusCode == 404) {
        throw const HeadlineNotFoundException('Headline not found');
      } else {
        throw const HeadlineUpdateException('Failed to update headline');
      }
    } catch (e) {
      throw const HeadlineUpdateException('Failed to update headline');
    }
  }

  @override
  Future<void> deleteHeadline(String id) async {
    try {
      final response = await httpClient.delete(
        Uri.parse('$baseUrl/headlines/$id'),
      );
      if (response.statusCode != 204) {
        throw const HeadlineDeletionException('Failed to delete headline');
      }
    } catch (e) {
      throw const HeadlineDeletionException('Failed to delete headline');
    }
  }
}
