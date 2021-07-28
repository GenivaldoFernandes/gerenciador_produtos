import 'dart:async';
import 'dart:io';

import 'package:gerenciador_produtos_confere/models/Produto.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {

  static final _databaseName = "bd_gerenciador_produtos_confere.db";
  static final _databaseVersion = 7;
  static final table = 'produtos';
  static final columnId = 'id';
  static final columnImagem = 'imagem';
  static final columnNome = 'nome';
  static final columnPreco = 'preco';
  static final columnPrecoPromo = 'preco_promocao';
  static final columnPercentualDesc = 'percentual_desconto';
  static final columnDisponivelVenda = 'disponivel_venda';

  // torna esta classe singleton
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async =>
      _database ??= await _initDatabase();

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnImagem TEXT,
            $columnNome TEXT NOT NULL,
            $columnPreco DOUBLE NOT NULL,
            $columnPrecoPromo DOUBLE,
            $columnPercentualDesc DOUBLE,
            $columnDisponivelVenda INTEGER
          )
          ''');
  }

  Future<void> create(Produto produto) async {
    Database db = await instance.database;
    await db.insert(
      table,
      produto.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Produto>> read() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(table);
    return List.generate(maps.length, (i) {
      return Produto(
        id: maps[i]['id'],
        imagem: maps[i]['imagem'],
        nome: maps[i]['nome'],
        preco: maps[i]['preco'],
        precoPromocao: maps[i]['preco_promocao'],
        percentualDesconto: maps[i]['percentual_desconto'],
        disponivelVenda: maps[i]['disponivel_venda'],
      );
    });
  }

  Future<List<Produto>> read2() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('SELECT * FROM $table ORDER BY $columnNome');
    return List.generate(maps.length, (i) {
      return Produto(
        id: maps[i]['id'],
        imagem: maps[i]['imagem'],
        nome: maps[i]['nome'],
        preco: maps[i]['preco'],
        precoPromocao: maps[i]['preco_promocao'],
        percentualDesconto: maps[i]['percentual_desconto'],
        disponivelVenda: maps[i]['disponivel_venda'],
      );
    });
  }

  Future<void> update(Produto produto) async {
    Database db = await instance.database;
    await db.update(
      table,
      produto.toMap(),
      where: 'id = ?',
      whereArgs: [produto.id],
    );
  }

  Future<void> delete(int id) async {
    Database db = await instance.database;
    await db.delete(
      table,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}