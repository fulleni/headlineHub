import 'package:headlinehub_dashboard/app/app.dart';
import 'package:headlinehub_dashboard/bootstrap.dart';
import 'package:headlinehub_headlines_client/headlinehub_headlines_client.dart';
import 'package:headlines_repository/headlines_repository.dart';
import 'package:http/http.dart' as http;

void main() {
  final httpClient = http.Client();
  final headlinesClient = HeadlinehubHeadlinesClient(
    'http://localhost:8080/api/v1',
    httpClient,
  );
  final headlinesRepository = HeadlinesRepository(headlinesClient);

  bootstrap(
    () async => App(
      headlinesRepository: headlinesRepository,
    ),
  );
}
