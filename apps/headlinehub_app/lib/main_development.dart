import 'package:headlinehub_app/app/app.dart';
import 'package:headlinehub_app/bootstrap.dart';
import 'package:headlineshub_headlines_client/headlineshub_headlines_client.dart';

void main() {
  final headlinesClint = HeadlinehubHeadlinesClient(baseUrl, httpClient)
  bootstrap(() => const App());
}
