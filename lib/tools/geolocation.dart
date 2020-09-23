import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:android_intent/android_intent.dart';

// Ceci contient 2 methodes (une pour avoir la position actuel de l'utilisateur,
// et une pour convertir la position en une addresse)
// et 2 variables (pour stocke la position et l'addresse)

final PermissionHandler permissionHandler = PermissionHandler();
Map<PermissionGroup, PermissionStatus> permissions;

// A funtion that asks about a permission
Future<bool> _requestPermission(PermissionGroup permission) async {
  final PermissionHandler _permissionHandler = PermissionHandler();
  var result = await _permissionHandler.requestPermissions([permission]);
  if (result[permission] == PermissionStatus.granted) {
    return true;
  }
  return false;
}

// A function that asks for location permission
Future<bool> requestLocationPermission({Function onPermissionDenied}) async {
  var granted = await _requestPermission(PermissionGroup.location);
  if (granted != true) {
    requestLocationPermission();
  }
  return granted;
}

/*Show dialog if GPS not enabled and open settings location*/
Future _checkGps(BuildContext context) async {
  if (!(await Geolocator().isLocationServiceEnabled())) {
    if (Theme.of(context).platform == TargetPlatform.android) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("On ne peut pas avoir la location actuelle"),
              content: const Text('SVP activer votre GPS et reessayer'),
              actions: <Widget>[
                FlatButton(
                    child: Text('Ok'),
                    onPressed: () {
                      final AndroidIntent intent = AndroidIntent(
                          action: 'android.settings.LOCATION_SOURCE_SETTINGS');
                      intent.launch();
                      Navigator.of(context, rootNavigator: true).pop();
                      gpsService(context);
                    })
              ],
            );
          });
    }
  }
}

/*Check if gps service is enabled or not*/
gpsService(BuildContext context) async {
  if (!(await Geolocator().isLocationServiceEnabled())) {
    _checkGps(context);
    return null;
  } else {
    return true;
  }
}
