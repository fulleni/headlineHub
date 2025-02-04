import 'package:dart_frog/dart_frog.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart' as shelf;

// ignore: public_member_api_docs
Middleware corsProvider() {
  return (handler) {
    return handler.use(
      fromShelfMiddleware(
        shelf.corsHeaders(
          headers: {
            shelf.ACCESS_CONTROL_ALLOW_ORIGIN: '*',
            shelf.ACCESS_CONTROL_ALLOW_METHODS:
                'GET, PUT, POST, DELETE, HEAD, OPTIONS',
          },
        ),
      ),
    );
  };
}
