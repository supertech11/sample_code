import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:xplor/util/ApiControler.dart';

class ApiService {
  static Future<String> getLanguageLabels(code) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a mobile network.
      print("I am connected to network");
      Response response;
      Dio dio = new Dio();
      dio.interceptors.add(LogInterceptor(requestBody: true));
      response = await dio.get("${ApiControler.base_url}/getLabel/${code}");
      if (response.statusCode == 200) {
        print(response.data.toString());
        return response.toString();
      } else {
        print(response.statusCode);

        return null;
      }
    } else {
      print("I am  not connected to a mobile network");
      return null;
    }
  }
}
