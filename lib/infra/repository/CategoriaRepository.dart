import 'package:relax_money/infra/repository/RepositoryBase.dart';
import 'package:relax_money/models/CategoriaModel.dart';
import 'package:sqflite/sqflite.dart';

class CategoriaRepository{

  var _repositoryBase = RepositoryBase();
  Database _database;

  listarCategorias() async {
    return await _carregarCategorias();
  }

  _carregarCategorias() async{
    _database = await _repositoryBase.database;
    List<CategoriaModel> categorias = List();

    var mapCategorias = await _database.rawQuery("SELECT ID, ICONE, DESCRICAO, ENTRADA FROM TB_CATEGORIA");

    for(var categoria in mapCategorias){
      categorias.add(CategoriaModel.fromMap(categoria));
    }

    return categorias;
  }


}