import 'package:relax_money/infra/repository/RepositoryBase.dart';
import 'package:relax_money/models/TransacaoModel.dart';
import 'package:sqflite/sqflite.dart';

class TransacaoRepository{

  var _repositoryBase = RepositoryBase();
  Database _database;

   Future<List<TransacaoModel>> listarTransacoesMes() async{
    return await _carregarTransacoes();

  }

  salvarTransacao(TransacaoModel transacao) async{
     _database = await _repositoryBase.database;

     _database.insert("TB_TRANSACAO", transacao.toMap());
  }

  removerTransacao(TransacaoModel transacao) async{
     _database = await _repositoryBase.database;

     await _database.delete(
         "TB_TRANSACAO",
         where: "ID = ?",
         whereArgs: [transacao.id]
     );
  }

  atualizarTransacao(TransacaoModel transacao) async{
     _database = await _repositoryBase.database;
      await _database.update(
       "TB_TRANSACAO",
       transacao.toMap(),
       where: "ID = ?",
       whereArgs: [transacao.id]
     );
  }

  Future<List<TransacaoModel>> _carregarTransacoes() async{
    _database = await _repositoryBase.database;
    List<TransacaoModel> transacoes = [];


    var mapTransacoes = await _database.rawQuery("SELECT T.ID, T.DESCRICAO, T.VALOR, T.DATA, T.FINALIZADO, T.ID_CATEGORIA, T.ID_CONTA, C.ICONE, C.DESCRICAO AS DESCRICAO_CATEGORIA, C.ENTRADA, CO.VALOR AS VALOR_CONTA, CO.CONTA_PADRAO FROM TB_TRANSACAO AS T INNER JOIN TB_CATEGORIA AS C ON T.ID_CATEGORIA = C.ID INNER JOIN TB_CONTA AS CO ON T.ID_CONTA = CO.ID");

    for(var transacao in mapTransacoes){
      transacoes.add(TransacaoModel.fromMap(transacao));
    }

    return transacoes;
  }


}