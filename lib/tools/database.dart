import 'dart:async';
import 'dart:io';
import 'package:eventapp/classes/publieur.dart';
import 'package:eventapp/classes/user_normal.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../classes/event.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // if _database is null we instantiate it
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "TestDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE User ("
          "nom TEXT,"
          "email TEXT,"
          "age TEXT,"
          "sexe TEXT,"
          "domaine TEXT,"
          "latitude REAL,"
          "longitude REAL,"
          "chois TEXT"
          ")");
      await db.execute("CREATE TABLE Publieur ("
          "nom TEXT,"
          "email TEXT,"
          "organisme TEXT"
          ")");
      await db.execute("CREATE TABLE Event ("
          "nom TEXT,"
          "prix TEXT,"
          "nbPlaceDispo TEXT,"
          "datedebut TEXT,"
          "datefin TEXT,"
          "latitude REAL,"
          "longitude REAL,"
          "contactEmail TEXT,"
          "contactNum TEXT,"
          "contactLien TEXT,"
          "description TEXT,"
          "age TEXT,"
          "sexe TEXT,"
          "domaine TEXT,"
          "photo TEXT,"
          "type TEXT,"
          "sousType TEXT"
          ")");
    });
  }

  newUser(Normal newUser) async {
    final db = await database;
    var res = await db.insert("User", newUser.toMap());
    return res;
  }

  newPublieur(Publieur newUser) async {
    final db = await database;
    var res = await db.insert("Publieur", newUser.toMap());
    return res;
  }

  newEvent(Event newEvent) async {
    final db = await database;
    var res = await db.insert("Event", newEvent.toMap());
    return res;
  }

  getUser(String email) async {
    final db = await database;
    var res = await db.query("User", where: "email = ?", whereArgs: [email]);
    return res.isNotEmpty ? Normal.fromMap(res.first) : null;
  }

  getPublieur(String email) async {
    final db = await database;
    var res = await db.query("User", where: "email = ?", whereArgs: [email]);
    return res.isNotEmpty ? Publieur.fromMap(res.first) : null;
  }

  Future<List<Event>> getAllEvents() async {
    final db = await database;
    var res = await db.query("Event");
    List<Event> list = res.isNotEmpty
        ? res.map((c) {
            var event = Event.fromMap(c);
            event.setLieu();
            return event;
          }).toList()
        : [];
    return list;
  }

  Future<List<Normal>> getAllUsers() async {
    final db = await database;
    var res = await db.query("User");
    List<Normal> list = res.isNotEmpty
        ? res.map((c) {
            var user = Normal.fromMap(c);
            return user;
          }).toList()
        : [];
    return list;
  }

  Future<List<Publieur>> getAllPubli() async {
    final db = await database;
    var res = await db.query("Publieur");
    List<Publieur> list = res.isNotEmpty
        ? res.map((c) {
            var user = Publieur.fromMap(c);
            return user;
          }).toList()
        : [];
    return list;
  }

  deleteUser(String email) async {
    final db = await database;
    return db.delete("User", where: "email = ?", whereArgs: [email]);
  }

  deletePublieur(String email) async {
    final db = await database;
    return db.delete("Publieur", where: "email = ?", whereArgs: [email]);
  }

  deleteEvent() async {
    final db = await database;
    return db
        .delete("Event", where: "nom != ?", whereArgs: ['Camping a Bouchaoui']);
  }

  deleteAllPublieur() async {
    final db = await database;
    db.rawDelete("Delete from Publieur");
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete from Event");
  }
}
