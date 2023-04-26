import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'articolo.dart';

class ArticoloDb {
  DatabaseFactory dbFactory = databaseFactoryIo;
  Database? _db;
  final store = intMapStoreFactory.store('articoli');

  static final ArticoloDb _singleton = ArticoloDb._internal();

  ArticoloDb._internal();

  factory ArticoloDb() {
    return _singleton;
  }

  Future<Database> init() async {
    _db ??= await _openDb();
    return _db!;
  }

  Future _openDb() async {
    final percorsoDocumenti = await getApplicationDocumentsDirectory();
    final percorsoDB = join(percorsoDocumenti.path, 'articoli.db');
    final db = await dbFactory.openDatabase(percorsoDB);

    return db;
  }

  Future inserisciArticolo(Articolo articolo) async {
    Database db = await _openDb();
    int id = await store.add(db, articolo.trasformaInMap());
  }

  Future<List<Articolo>> leggiArticoli() async {
    if (_db == null) {
      await init();
    }

    final finder = Finder(sortOrders: [SortOrder('id')]);

    final articoliSnapshot = await store.find(_db!, finder: finder);

    return articoliSnapshot.map((e) {
      final articolo = Articolo.daMap(e.value);
      articolo.id = e.key;
      return articolo;
    }).toList();
  }

  Future aggiornaArticolo(Articolo articolo) async {
    final finder = Finder(filter: Filter.byKey(articolo.id));
    await store.update(_db!, articolo.trasformaInMap(), finder: finder);
  }

  Future eliminaArticolo(Articolo articolo) async {
    final finder = Finder(filter: Filter.byKey(articolo.id));
    await store.delete(_db!, finder: finder);
  }

  Future eliminaDatiDb() async {
    await store.delete(_db!);
  }
}
