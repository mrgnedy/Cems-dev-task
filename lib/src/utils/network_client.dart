import 'package:dio/dio.dart';

class CacheInterceptor extends Interceptor {
  CacheInterceptor();

  final _cache = <Uri, Response>{};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final response = _cache[options.uri];
    if (options.extra['refresh'] == true) {
      print('${options.uri}: force refresh, ignore cache! \n');
      return handler.next(options);
    } else if (response != null) {
      print('cache hit: ${options.uri} \n');
      return handler.resolve(response);
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _cache[response.requestOptions.uri] = response;
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    print('onError: $err');
    super.onError(err, handler);
  }
}

class NetworkClient {
  final dio = Dio()
    ..options.baseUrl = "https://api.github.com"
    ..interceptors.add(CacheInterceptor());

  Future<Response> get(String url, [bool force = false]) async {
    final response = await dio.get('/', options: Options(extra: {'refresh': force}));
    if(response.statusCode == 200 || response.statusCode ==201){

    }
    
    return response;
  }
}
