import 'package:dart_frog/dart_frog.dart';
import 'package:in_memory_headlines_client/in_memory_headlines_client.dart';

final _inMemoryHeadlinesClient = InMemoryHeadlinesClient();

/// Provide a [InMemoryHeadlinesClient] to the current [RequestContext]
Middleware inMemoryHeadlinesClientProvider() {
  return (handler) {
    return handler.use(
      provider<InMemoryHeadlinesClient>((context) => _inMemoryHeadlinesClient),
    );
  };
}
