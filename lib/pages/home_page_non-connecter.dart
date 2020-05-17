import 'dart:async';

import 'package:eventapp/classes/event.dart';
import 'package:eventapp/widgets.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uic/list_uic.dart';

class NoConnection extends StatefulWidget {
  NoConnection({Key key, this.title}) : super(key: key);

  final String title;

  @override
  NoConnectionState createState() => NoConnectionState();
}

class NoConnectionState extends State<NoConnection> {
  // final FirebaseMessaging _fcm = new FirebaseMessaging();

  // StreamSubscription iosSubscription;

  ListUicController<Event> uic;

  List<Event> listevent = List<Event>();

  void initlist() {
    listevent.add(e);
    listevent.add(e);
    listevent.add(e);
  }

  Future<List<Event>> _getItems(int page) async {
    await Future.delayed(Duration(seconds: 3));
    List<Event> list = new List<Event>();
    int i = 1;
    while (listevent.length > ((page - 1) * 11) && i <= 10) {
      list.add(listevent[(page - 1) * 10 + i]);
      i++;
    }
    return list;
  }

  @override
  void initState() {
    super.initState();

    uic = ListUicController<Event>(
      onGetItems: (int page) => _getItems(page),
    );
    initlist();
    initlist();
    initlist();
    initlist();
    initlist();
    initlist();
    initlist();
    initlist();
    initlist();

    // if (Platform.isIOS) {
    //   iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
    //     // save the token  OR subscribe to a topic here
    //   });

    //   _fcm.requestNotificationPermissions(IosNotificationSettings());
    // }

    // _fcm.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     print("onMessage: $message");
    //     showDialog(
    //       context: context,
    //       builder: (context) => AlertDialog(
    //         content: ListTile(
    //           title: Text(message['notification']['title']),
    //           subtitle: Text(message['notification']['bSERbess1991ody']),
    //         ),
    //         actions: <Widget>[
    //           FlatButton(
    //             child: Text('Ok'),
    //             onPressed: () => Navigator.of(context).pop(),
    //           ),
    //         ],
    //       ),
    //     );
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     print("onLaunch: $message");
    //     // TODO optional
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     print("onResume: $message");
    //     // TODO optional
    //   },
    // );
    // _fcm.getToken().then((String token) {
    //   assert(token != null);
    //   print(token);
    // });
  }

  Event e = new Event(
      "Nom de l'evenement",
      "Decription de l'evenement",
      DateTime.now(),
      DateTime.now().add(Duration(days: 5)),
      Position(latitude: 36.7538, longitude: 3.0588),
      "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Liste event test"),
        elevation: 10,
        backgroundColor: Colors.white,
      ),
      body: listEvent(uic, context),
      backgroundColor: Colors.white,
    );
  }
}
