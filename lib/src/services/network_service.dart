import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:laundry/src/models/get_laundry.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/get_user_model.dart';
import '../models/login_model.dart';
import '../models/response.dart';

class NetworkService {
  NetworkService._internal();
  static final NetworkService _instance = NetworkService._internal();

  factory NetworkService() => _instance;
  static final Dio _dio = Dio()
    ..interceptors.add(
      InterceptorsWrapper(
        onRequest: (requestOptions, handler) async {
          requestOptions.connectTimeout = 5000;
          requestOptions.receiveTimeout = 5000;
          requestOptions.baseUrl = 'http://student.crru.ac.th/611413005/bn';

          return handler.next(requestOptions);
        },
        onResponse: (response, handler) async {
          return handler.next(response);
        },
        onError: (dioError, handler) async {
          return handler.next(dioError);
        },
      ),
    );

  Future<LoginModel> login(
    final String username,
    final String password,
  ) async {
    var formData = FormData.fromMap({
      'username': username,
      'password': password,
    });

    final response = await _dio.post(
      '/login/login.php',
      data: formData,
    );

    return loginModelFromJson(jsonEncode(response.data));
  }

  Future<ResponseModel> register(
    final String name,
    final String username,
    final String password,
  ) async {
    var formData = FormData.fromMap({
      'name': name,
      'username': username,
      'password': password,
    });
    final response = await _dio.post(
      '/login/singup.php',
      data: formData,
    );
    return responseModelFromJson(jsonEncode(response.data));
  }

  Future<ResponseModel> reserve(String token, int status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String id = prefs.getString('token') ?? '';
    var formData = FormData.fromMap({
      'token': token,
      'status': status,
      'userid': id,
    });
    final response = await _dio.post('/luandry/post.php', data: formData);
    return responseModelFromJson(jsonEncode(response.data));
  }

  Future<ResponseModel> topup(int price) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String id = prefs.getString('token') ?? '';
    var formData = FormData.fromMap({
      'token': id,
      'price': price,
    });
    final response = await _dio.post('/topup/post.php', data: formData);
    print(jsonEncode(response.data));
    return responseModelFromJson(jsonEncode(response.data));
  }

  Future<UserModel> getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String id = prefs.getString('token') ?? '';
    final response = await _dio.get('/topup?id=$id');

    return userModelFromJson(jsonEncode(response.data));
  }

  Future<List<GetLaundryModel>> getData() async {
    final response = await _dio.get('/luandry');
    return getLaundryModelFromJson(jsonEncode(response.data));
  }
}
