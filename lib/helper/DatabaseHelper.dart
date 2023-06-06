import 'package:posumkm/models/JenisMenuModel.dart';
import 'package:posumkm/models/UserModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

UserModel? userModel;

class DatabaseHelper {
  static const _version = 1;
  static const _dbName = "db_posumkmws.db";

  static Future<Database> _getDb() async {
    return openDatabase(join(await getDatabasesPath(), _dbName),
        onCreate: (db, version) {
      return db.execute(
        // ignore: prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings
        "CREATE TABLE m_jenis_menu" +
            "(id INTEGER PRIMARY KEY," +
            "id_m_merchant INTEGER," +
            "nama_jenis_menu TEXT" +
            "deskripsi TEXT" +
            ");" +
            "CREATE TABLE m_kategori_menu" +
            "(id INTEGER PRIMARY KEY," +
            "id_m_jenis_menu INTEGER," +
            "id_m_merchant INTEGER," +
            "nama_kategori_menu TEXT" +
            "deskripsi TEXT" +
            ");" +
            "CREATE TABLE m_menu_merchant" +
            "(id INTEGER PRIMARY KEY," +
            "id_m_jenis_menu INTEGER," +
            "id_m_kategori_menu INTEGER," +
            "id_m_merchant INTEGER," +
            "nama_menu_merchant TEXT" +
            "harga INTEGER" +
            "deskripsi TEXT" +
            ");",
      );
    }, version: _version);
  }

  static Future<int> insertJenisMenu(JenisMenuModel data) async {
    final db = await _getDb();
    return await db.insert("m_jenis_menu", data.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deleteJenisMenu(JenisMenuModel data) async {
    final db = await _getDb();
    return await db
        .delete("m_jenis_menu", where: "id = ?", whereArgs: [data.id]);
  }

  static Future<List<JenisMenuModel>?> getAllJenisMenu() async {
    final db = await _getDb();
    final List<Map<String, dynamic>> maps = await db.query("m_jenis_menu");

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(maps.length, (index) => JenisMenuModel.fromJson(maps[index]));
  }
}