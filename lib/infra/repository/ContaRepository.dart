import 'package:relax_money/infra/repository/RepositoryBase.dart';
import 'package:relax_money/models/ContaModel.dart';
import 'package:sqflite/sqflite.dart';

class ContaRepository{

  var _repositoryBase = RepositoryBase();
  Database _database;

  Future<List<ContaModel>> listaContas() async{
    return await _carregarContas();
  }

  atualizarConta(ContaModel conta) async{
    _database = await _repositoryBase.database;

    await _database.update(
      "TB_CONTA",
      conta.toMap(),
      where: "ID = ?",
      whereArgs: [conta.id]

    );
  }

  Future<List<ContaModel>> _carregarContas() async{
    _database = await _repositoryBase.database;
    List<ContaModel> contas = List();

    var mapContas = await _database.rawQuery("SELECT ID, DESCRICAO, VALOR, CONTA_PADRAO FROM TB_CONTA");

    for(var conta in mapContas){
      contas.add(ContaModel.fromMap(conta));
    }

    return contas;
  }
}