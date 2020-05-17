import 'package:geolocator/geolocator.dart';

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

    currentAddress =
        "${place.locality}, ${place.country}";
  } catch (e) {
    print(e);
  }
}
