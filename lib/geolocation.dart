import 'package:geolocator/geolocator.dart';

// Ceci contient 2 methodes (une pour avoir la position actuel de l'utilisateur,
// et une pour convertir la position en une addresse)
// et 2 variables (pour stocke la position et l'addresse)

final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
Position currentPosition;
String currentAddress;

getCurrentLocation() {
  geolocator
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
      .then((Position position) {
    currentPosition = position;

    getAddressFromLatLng();
  }).catchError((e) {
    print(e);
  });
}

getAddressFromLatLng() async {
  try {
    List<Placemark> p = await geolocator.placemarkFromCoordinates(
        currentPosition.latitude, currentPosition.longitude);

    Placemark place = p[0];

    currentAddress = "${place.locality}, ${place.country}";
  } catch (e) {
    print(e);
  }
}
