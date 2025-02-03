// ignore_for_file: avoid_redundant_argument_values

import 'dart:convert';

import 'package:headlinehub_models/headlinehub_models.dart';
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

  @override
  Future<PaginatedResponse<Headline>> getHeadlines([
    HeadlineQueryOptions? options,
  ]) async {
    try {
      final response = await httpClient.get(Uri.parse('$baseUrl/headlines'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return PaginatedResponse<Headline>.fromJson(
          data,
          (json) => Headline.fromJson(json! as Map<String, dynamic>),
        );
      } else {
        throw const HeadlineCategoryException('Failed to fetch headlines');
      }
    } catch (e) {
      throw const HeadlineCategoryException('Failed to fetch headlines');
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
      final response =
          await httpClient.delete(Uri.parse('$baseUrl/headlines/$id'));
      if (response.statusCode != 204) {
        throw const HeadlineDeletionException('Failed to delete headline');
      }
    } catch (e) {
      throw const HeadlineDeletionException('Failed to delete headline');
    }
  }

  @override
  Future<PaginatedResponse<Headline>> getHeadlinesByQuery(
    String query, [
    HeadlineQueryOptions? options,
  ]) async {
    try {
      final response =
          await httpClient.get(Uri.parse('$baseUrl/headlines?query=$query'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return PaginatedResponse<Headline>.fromJson(
          data,
          (json) => Headline.fromJson(json! as Map<String, dynamic>),
        );
      } else {
        throw const HeadlineSearchingException('Failed to search headlines');
      }
    } catch (e) {
      throw const HeadlineSearchingException('Failed to search headlines');
    }
  }

  @override
  Future<PaginatedResponse<Headline>> getHeadlinesByCategory(
    HeadlineCategory category, [
    HeadlineQueryOptions? options,
  ]) async {
    try {
      final response = await httpClient
          .get(Uri.parse('$baseUrl/headlines?category=${category.name}'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return PaginatedResponse<Headline>.fromJson(
          data,
          (json) => Headline.fromJson(json! as Map<String, dynamic>),
        );
      } else {
        throw const HeadlineCategoryException(
          'Failed to fetch headlines for category',
        );
      }
    } catch (e) {
      throw const HeadlineCategoryException(
        'Failed to fetch headlines for category',
      );
    }
  }

  @override
  Future<PaginatedResponse<Headline>> getHeadlinesByDateRange(
    DateTime startDate,
    DateTime endDate, [
    HeadlineQueryOptions? options,
  ]) async {
    try {
      final response = await httpClient.get(
        Uri.parse(
          '$baseUrl/headlines?startDate=${startDate.toIso8601String()}&endDate=${endDate.toIso8601String()}',
        ),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return PaginatedResponse<Headline>.fromJson(
          data,
          (json) => Headline.fromJson(json! as Map<String, dynamic>),
        );
      } else {
        throw const HeadlineDateRangeException(
          'Failed to fetch headlines for date range',
        );
      }
    } catch (e) {
      throw const HeadlineDateRangeException(
        'Failed to fetch headlines for date range',
      );
    }
  }
}
