import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:device_info/device_info.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

// Ceci est un ensemble methodes et variables pour effectuer des requetes get et post
// et pour gerer l'authentification
// Peut etre ca contient des methodes ou des variables qu'on n'a pas besoin (pour l'instant)

// the unique ID of the application
const String _applicationId = "my_application_id";

// the storage key for the token
const String _storageKeyMobileToken = "token";

// the URL of the Web Server
const String _urlBase = "http://10.0.2.2:5000";

// the URI to the Web Server Web API
const String _serverApi = "/";

// the mobile device unique identity
String _deviceIdentity = "";

/// ----------------------------------------------------------
/// Method which is only run once to fetch the device identity
/// ----------------------------------------------------------
final DeviceInfoPlugin _deviceInfoPlugin = new DeviceInfoPlugin();

Future<String> _getDeviceIdentity() async {
  if (_deviceIdentity == '') {
    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo info = await _deviceInfoPlugin.androidInfo;
        _deviceIdentity = "${info.device}-${info.id}";
      } else if (Platform.isIOS) {
        IosDeviceInfo info = await _deviceInfoPlugin.iosInfo;
        _deviceIdentity = "${info.model}-${info.identifierForVendor}";
      }
    } on PlatformException {
      _deviceIdentity = "unknown";
    }
  }

  return _deviceIdentity;
}

/// ----------------------------------------------------------
/// Method that returns the token from Shared Preferences
/// ----------------------------------------------------------

Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

Future<String> _getMobileToken() async {
  final SharedPreferences prefs = await _prefs;

  return prefs.getString(_storageKeyMobileToken) ?? '';
}

/// ----------------------------------------------------------
/// Method that saves the token in Shared Preferences
/// ----------------------------------------------------------
Future<bool> _setMobileToken(String token) async {
  final SharedPreferences prefs = await _prefs;

  return prefs.setString(_storageKeyMobileToken, token);
}

/// ----------------------------------------------------------
/// Http Handshake
///
/// At application start up, the application needs to synchronize
/// with the server.
/// How does this work?
///   - A. If a previous token exists, the latter is sent to
///   -   the server to be validated.  If the validation is Ok,
///   -   the user is re-authenticated and a new token is returned
///   -   to the application.  The application then stores it.
///
///   - B. If no token exists, the application sends a request
///   -   for a new token to the server, which returns the
///   -   the requested token.  This token will be saved.
/// ----------------------------------------------------------
Future<String> handShake() async {
  String _status = "ERROR";

  return getRequest("handshake", {
    'X-DEVICE-ID': await _getDeviceIdentity(),
    'X-TOKEN': await _getMobileToken(),
    'X-APP-ID': _applicationId
  }).then((String responseBody) async {
    Map response = json.decode(responseBody);
    _status = response["status"];
    switch (_status) {
      case "REQUIRES_AUTHENTICATION":
        // We received a new token, so let's save it.
        await _setMobileToken(response["data"]);
        break;

      case "INVALID":
        // The token we passed in invalid ??  why ?? somebody played with the local storage?
        // Anyways, we need to remove the previous one from the local storage,
        // and proceed with another handshake
        await _setMobileToken("");
        break;

      //TODO: add other cases
    }

    return _status;
  }).catchError(() {
    return "ERROR";
  });
}

/// ----------------------------------------------------------
/// Http "GET" request
/// ----------------------------------------------------------
Future<String> getRequest(String serviceName, Map<String, String> c) async {
  var responseBody = '{"data": "", "status": "NOK"}';
  try {
    var response = await http.get(
      _urlBase + '$_serverApi$serviceName',
    );

    print(response.statusCode);
    if (response.statusCode == 200) {
      responseBody = response.body;
    }
  } catch (e) {
    // An error was received
    throw new Exception("GET ERROR");
  }
  return responseBody;
}

//  'X-DEVICE-ID': await _getDeviceIdentity(),
//  'X-TOKEN': await _getMobileToken(),
//  'X-APP-ID': _applicationId

/// ----------------------------------------------------------
/// Http "POST" request
/// ----------------------------------------------------------
Future<Map> postRequest(String serviceName, Map<String, dynamic> data) async {
  var responseBody = json.decode('{"data": "", "status": "NOK"}');
  try {
    http.Response response = await http.post(
      _urlBase + '$_serverApi$serviceName',
      headers: {'Content-type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      responseBody = json.decode(response.body);
      //
      // If we receive a new token, let's save it
      //
      // if (responseBody["status"] == "TOKEN") {
      //   await _setMobileToken(responseBody["data"]);

      //   // TODO: rerun the Post request
      // }
    }
  } catch (e) {
    // An error was received
    throw new Exception("POST ERROR");
  }
  return responseBody;
}
