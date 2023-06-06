import 'package:posumkm/models/UserModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

UserModel? userModel;

void main() async {
  final database = openDatabase(
    join(await getDatabasesPath(), "db_posumkmws.db"),
    onCreate: (db, version) {
      return db.execute(
        // ignore: prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings
        "CREATE TABLE m_jenis_menu"+
        "(id INTEGER PRIMARY KEY,"+
        "id_m_merchant INTEGER,"+
        "nama_jenis_menu TEXT"+
        "deskripsi TEXT"+
        ")",
      );
    },
  );
}