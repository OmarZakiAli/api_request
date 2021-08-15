import 'package:dio/dio.dart';

import '../api_request_options.dart';

class UnauthenticatedInterceptor extends Interceptor {
  String _tag = 'unauthenticated';
  @override
  void onError(DioError error, ErrorInterceptorHandler handler) {
    if (error.response?.statusCode == 401) {
      ApiRequestOptions.instance?.unauthenticated!();
    }
    super.onError(error, handler);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UnauthenticatedInterceptor &&
          runtimeType == other.runtimeType &&
          _tag == other._tag;

  @override
  int get hashCode => _tag.hashCode;
}