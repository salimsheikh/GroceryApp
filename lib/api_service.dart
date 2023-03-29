// ignore_for_file: unused_import
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';

import 'config.dart';
import 'models/customer.dart';

class APIService {
  Future<bool> createCustomer(CustomerModel model) async {
    var authToken = base64.encode(
      utf8.encode("Config.key:{Config.secret}"),
    );

    bool ret = false;

    try {
      var response = await Dio().post(Config.url + Config.customerURL,
          data: model.toJson(),
          options: Options(headers: {
            HttpHeaders.authorizationHeader: 'basic $authToken',
            HttpHeaders.contentTypeHeader: "application/json"
          }));
      if (response.statusCode == 201) {
        return ret;
      }
    } on DioError catch (e) {
      if (e.response!.statusCode == 404) {
        ret = false;
      } else {
        ret = false;
      }
    }
    return ret;
  }
}
