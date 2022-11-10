import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import '../models/item_model.dart';
import 'repository.dart';

class NewsDbProvider implements Source, Cache {
  Database? db;

  NewsDbProvider() {
    init();
  }

  void init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, "items2.db");
    db = await openDatabase(path, version: 1,
        onCreate: (Database newDb, int version) {
      newDb.execute("""
             CREATE TABLE Items 
              (
                id INTEGER PRIMARY KEY, 
                type TEXT, 
                by TEXT, 
                time INTEGER, 
                text INTEGER,
                parent INTEGER, 
                kids BLOB, 
                dead INTEGER, 
                deleted INTEGER,
                url TEXT, 
                score INTEGER,
                title TEXT, 
                descendants INTEGER
              )
          """);
    });
  }

  Future<ItemModel> fetchItem(int id) async {
    final maps = await db!.query("Items", columns: null, where: "id = ?", whereArgs: [id]);
    if (maps.isNotEmpty) {
      return ItemModel.fromDb(maps.first);
    }

    return ItemModel.asNull();
  }

  Future<int> addItem(ItemModel item) {

        return db?.insert("Items", item.toMapForDb(),
            conflictAlgorithm: ConflictAlgorithm.ignore) ?? null as Future<int>;

  }

  @override
  Future<List<int>> fetchTopIds() {
    return null as Future<List<int>>;
  }

  Future<int> clear() {
    return db?.delete('Items') ?? null as Future<int>;
  }

}

final newsDbProvider = NewsDbProvider();
