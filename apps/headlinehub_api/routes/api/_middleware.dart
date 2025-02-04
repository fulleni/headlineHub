import 'package:dart_frog/dart_frog.dart';
import 'package:headlinehub_api/middlewares/in_memory_headlines_provider.dart';


Handler middleware(Handler handler) {
  return handler.use(inMemoryHeadlinesClientProvider()) ;
}
