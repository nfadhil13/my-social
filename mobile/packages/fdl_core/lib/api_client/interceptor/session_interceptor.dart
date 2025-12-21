part of '../api_client.dart';

class SessionInterceptor extends Interceptor {
  final SessionHandler? getUserSession;

  SessionInterceptor({this.getUserSession});

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final getUserSession = this.getUserSession;
      if (getUserSession == null) {
        return handler.next(options);
      }
      final session = await getUserSession.getSession();
      if (session == null) {
        return handler.next(options);
      }
      final apiSession = session.asApiSession();
      if (apiSession == null) {
        return handler.next(options);
      }
      return handler.next(
        options.copyWith(
          headers: {
            ...options.headers,
            if (apiSession.headers != null) ...apiSession.headers!,
          },
          queryParameters: {
            ...options.queryParameters,
            if (apiSession.query != null) ...apiSession.query!,
          },
        ),
      );
    } catch (e, stackTrace) {
      debugPrint("Error SessionInterceptor: $e");
      debugPrintStack(stackTrace: stackTrace);
      return handler.next(options);
    }
  }

  dynamic expandData(dynamic data, Map<String, dynamic>? body) {
    if (data == null || body == null) return data;
    if (data is FormData) {
      data.fields.addAll(
        body.entries.map((e) => MapEntry(e.key, e.value.toString())),
      );
    }
    return {...(data ?? {}), ...body};
  }
}
