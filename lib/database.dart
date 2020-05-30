import 'dart:async';
import 'dart:io';
import 'package:eventapp/classes/publieur.dart';
import 'package:eventapp/classes/user_normal.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'classes/event.dart';

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
          "registerId INTEGER PRIMARY KEY,"
          "nom TEXT,"
          "prenom TEXT,"
          "email TEXT,"
          "age TEXT,"
          "sexe TEXT,"
          "profession,"
          "numtel INTEGER,"
          "latitude REAL,"
          "longitude REAL,"
          ")");
      await db.execute("CREATE TABLE Publieur ("
          "registerId INTEGER PRIMARY KEY,"
          "nom TEXT,"
          "prenom TEXT,"
          "email TEXT,"
          "numtel INTEGER,"
          "nomSociete TEXT,"
          ")");
      await db.execute("CREATE TABLE Event ("
          "nom TEXT,"
          "corps TEXT,"
          "datedebut TEXT,"
          "datefin TEXT,"
          "photoUrl TEXT,"
          "latitude REAL,"
          "longitude REAL,"
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

  // updateUser(User newUser) async {
  //   final db = await database;
  //   var res = await db.update("User", newUser.toMap(),
  //       where: "id = ?", whereArgs: [newUser.id]);
  //   return res;
  // }

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
    List<Event> list =
        res.isNotEmpty ? res.map((c) => Event.fromMap(c)).toList() : [];
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

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete * from Event");
  }
}
