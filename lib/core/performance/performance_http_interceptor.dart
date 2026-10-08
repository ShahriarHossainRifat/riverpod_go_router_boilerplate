import 'package:dio/dio.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_go_router_boilerplate/core/performance/performance_service.dart';

/// Dio interceptor that automatically traces HTTP requests with Firebase Performance.
///
/// Add this interceptor to your Dio instance to automatically track:
/// - Request duration
/// - Response size
/// - HTTP status codes
/// - Success/failure rates
///
/// ## Usage:
///
/// ```dart
/// final dio = Dio();
/// dio.interceptors.add(PerformanceHttpInterceptor(ref));
/// ```
///
/// ## What's Tracked:
/// - Request URL (path only, no query params for privacy)
/// - HTTP method (GET, POST, PUT, DELETE, etc.)
/// - Response time
/// - Response payload size
/// - HTTP status code
/// - Content type
class PerformanceHttpInterceptor extends Interceptor {
  /// Creates a [PerformanceHttpInterceptor] instance.
  new(this._ref);

  final Ref _ref;

  /// Key to store the HttpMetric in request extras.
  static const _metricKey = '_performance_http_metric';

  PerformanceService get _performanceService =>
      _ref.read(performanceServiceProvider);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_performanceService.isEnabled) {
      final method = _mapMethod(options.method);
      final url = _sanitizeUrl(options.uri);

      final metric = _performanceService.newHttpMetric(url, method);
      if (metric != null) {
        // ignore: discarded_futures - fire and forget
        metric.start();
        // Store metric in extras for later use
        options.extra[_metricKey] = metric;
      }
    }

    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _finishMetric(
      response.requestOptions,
      statusCode: response.statusCode,
      contentType: response.headers.value('content-type'),
      responsePayloadSize: _getResponseSize(response),
    );

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _finishMetric(
      err.requestOptions,
      statusCode: err.response?.statusCode,
      contentType: err.response?.headers.value('content-type'),
      responsePayloadSize: err.response != null
          ? _getResponseSize(err.response!)
          : null,
    );

    handler.next(err);
  }

  void _finishMetric(
    RequestOptions options, {
    int? statusCode,
    String? contentType,
    int? responsePayloadSize,
  }) {
    final metric = options.extra[_metricKey] as HttpMetric?;
    if (metric == null) return;

    try {
      if (statusCode != null) {
        metric.httpResponseCode = statusCode;
      }

      if (contentType != null) {
        metric.responseContentType = contentType;
      }

      if (responsePayloadSize != null) {
        metric.responsePayloadSize = responsePayloadSize;
      }

      // Request payload size
      final requestData = options.data;
      if (requestData != null) {
        final size = _calculateSize(requestData);
        if (size > 0) {
          metric.requestPayloadSize = size;
        }
      }

      // ignore: discarded_futures - fire and forget
      metric.stop();
    } catch (_) {
      // Silently fail if metric operations fail
    }
  }

  int? _getResponseSize(Response<dynamic> response) {
    try {
      final data = response.data;
      if (data == null) return null;
      return _calculateSize(data);
    } catch (_) {
      return null;
    }
  }

  int _calculateSize(dynamic data) {
    if (data is String) {
      return data.length;
    } else if (data is List<int>) {
      return data.length;
    } else if (data is Map || data is List) {
      // Rough estimation for JSON
      return data.toString().length;
    }
    return 0;
  }

  String _sanitizeUrl(Uri uri) {
    // Remove query parameters for privacy
    // Only keep scheme, host, and path
    return '${uri.scheme}://${uri.host}${uri.path}';
  }

  HttpMethod _mapMethod(String method) {
    switch (method.toUpperCase()) {
      case 'GET':
        return HttpMethod.Get;
      case 'POST':
        return HttpMethod.Post;
      case 'PUT':
        return HttpMethod.Put;
      case 'DELETE':
        return HttpMethod.Delete;
      case 'PATCH':
        return HttpMethod.Patch;
      case 'OPTIONS':
        return HttpMethod.Options;
      default:
        return HttpMethod.Get;
    }
  }
}
