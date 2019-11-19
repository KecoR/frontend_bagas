import 'package:tour_guide_rental/providers/auth.dart';

class AppConstants {
  //Nama Aplikasi
  static final String appName = 'Tour Guide Rental';

  // static const String ip = 'http://172.20.15.252:8000/'; //Kantor
  // static const String ip = 'http://192.168.100.6:8000/'; //Kevin
  // static const String ip = 'http://192.168.1.7:8000/'; //Lucky
  // static const String ip = 'http://192.168.1.77:8000/'; //Made
  // static const String ip = 'http://192.168.43.172:8000/'; //Bagas
  // static const String ip = 'http://192.168.1.29:8000/'; //Shell
  // static const String ip = 'http://192.168.1.101:8000/'; //Kampus
  static const String ip = 'http://192.168.100.35:8000/'; //PC

  //API Url
  static const String urlApi = ip + 'api/v1/';

  //Image url
  static const String urlImage = ip + 'image/museums/';

  //Image User url
  static const String urlUserImage = ip + 'image/users/';

  static Auth currentUser;

  static final Map<int, String> monthDict = {
    1: "January",
    2: "February",
    3: "March",
    4: "April",
    5: "May",
    6: "June",
    7: "July",
    8: "August",
    9: "September",
    10: "October",
    11: "November",
    12: "December",
  };
}
