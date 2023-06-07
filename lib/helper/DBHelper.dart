import 'dart:async';
import 'dart:core';

import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart';

import '../models/JenisMenuModel.dart';

class DBHelper{
  static Future<void> createTables(sql.Database database) async {
    // ignore: prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings
    await database.execute("CREATE TABLE m_jenis_menu" +
            "(id INTEGER PRIMARY KEY AUTO_INCREMENT," +
            "id_m_merchant INTEGER," +
            "nama_jenis_menu TEXT" +
            "deskripsi TEXT" +
            ");" +
            "CREATE TABLE m_kategori_menu" +
            "(id INTEGER PRIMARY KEY AUTO_INCREMENT," +
            "id_m_jenis_menu INTEGER," +
            "id_m_merchant INTEGER," +
            "nama_kategori_menu TEXT" +
            "deskripsi TEXT" +
            ");" +
            "CREATE TABLE m_menu_merchant" +
            "(id INTEGER PRIMARY KEY AUTO_INCREMENT," +
            "id_m_jenis_menu INTEGER," +
            "id_m_kategori_menu INTEGER," +
            "id_m_merchant INTEGER," +
            "nama_menu_merchant TEXT" +
            "harga INTEGER" +
            "deskripsi TEXT" +
            ");");
  }

  static Future<sql.Database> db() async{
    return sql.openDatabase("db_posumkmws.db", version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      });
  }

  static Future<void> insertListJenisMenu(List<JenisMenuModel> obj) async {
    final db = await DBHelper.db();

    for(var i; i < obj.length; i++){
      print("inserting "+obj[i].nama_jenis_menu);
      await db.insert("m_jenis_menu", obj[i].toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }
}