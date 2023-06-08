import 'dart:async';
import 'dart:core';
import 'package:path/path.dart';


// import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import '../models/JenisMenuModel.dart';

class DBHelper{
  static Future<void> createTables(Database database) async {
    // ignore: prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings
    await database.execute('''
        CREATE TABLE m_jenis_menu
            (id INTEGER PRIMARY KEY,
            id_m_merchant INTEGER,
            nama_jenis_menu TEXT,
            deskripsi TEXT
            )''');
    await database.execute('''
        CREATE TABLE m_kategori_menu
            (id INTEGER PRIMARY KEY,
            id_m_jenis_menu INTEGER,
            id_m_merchant INTEGER,
            nama_kategori_menu TEXT,
            deskripsi TEXT
            )''');
    await database.execute('''
        CREATE TABLE m_menu_merchant
            (id INTEGER PRIMARY KEY,
            id_m_jenis_menu INTEGER,
            id_m_kategori_menu INTEGER,
            id_m_merchant INTEGER,
            nama_menu_merchant TEXT,
            harga INTEGER,
            deskripsi TEXT
            )''');
  }

  static Future<Database> db() async{
    // final options = OpenDatabaseOptions(
    //   version: 1, singleInstance: true,
    // )
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "db_posumkmws.db");
    return await databaseFactory.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (db, version) async {
          await createTables(db);
        },
      )
    ); 
  }

  static Future<void> insertListJenisMenu(List<JenisMenuModel> obj) async {
    final db = await DBHelper.db();

    for(var i = 0; i < obj.length; i++){
      await db.insert("m_jenis_menu", obj[i].toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    }

    // List<Map<String, dynamic>> result = await db.query("m_jenis_menu");
    // print("the data "+result.length.toString());
  }

  static Future<List<JenisMenuModel>> getAllJenisMenu() async {
    final db = await DBHelper.db();
    List<JenisMenuModel> rs = [];

    List<Map<String, dynamic>> result = await db.query("m_jenis_menu");
    for(var i = 0; i < result.length; i++){
      final temp = JenisMenuModel.fromJson(result[i]);
      rs.add(temp);
    }

    return rs;
  }
}