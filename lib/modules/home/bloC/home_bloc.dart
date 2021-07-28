import 'package:diacritic/diacritic.dart';
import 'package:gerenciador_produtos_confere/models/Produto.dart';
import 'package:gerenciador_produtos_confere/providers/bd_local.dart';

class HomeBloc{
  final dbHelper = DatabaseHelper.instance;

  Future<void> create(Produto produto) async {
      await dbHelper.create(produto);
  }

  Future<List<Produto>> read() async {
    return await dbHelper.read2();
  }

  Future<void> update(Produto produto) async {
    await dbHelper.update(produto);
  }

  Future<void> delete(int id) async {
    await dbHelper.delete(id);
  }

  List filter (String name, var listaCompleta) {
    return listaCompleta.
    where((c) =>
    (removeDiacritics(c.toString())
        .toLowerCase().contains(removeDiacritics(name.toLowerCase()))))
        .toList();
  }
}