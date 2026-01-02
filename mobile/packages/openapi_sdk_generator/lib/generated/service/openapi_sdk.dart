import 'package:dio/dio.dart';
import 'index.dart';

class Service {
  Service(this._dio) : authservice = AuthService(_dio);

  final Dio _dio;

  final AuthService authservice;
}
