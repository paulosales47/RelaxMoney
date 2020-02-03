import 'package:decimal/decimal.dart';
import 'package:relax_money/infra/repository/RepositoryBase.dart';
import 'package:relax_money/models/BalancoModel.dart';
import 'package:sqflite/sqflite.dart';

class BalancoRepository{

  var _repositoryBase = RepositoryBase();
  Database _database;

  Future<BalancoModel> carregarBalanco() async {

    var balanco = BalancoModel(
        await _calcularValorTotal(),
        await _calcularValorTotalFechamento()
    );

    return balanco;
  }
  
  Future<Decimal> _calcularValorTotal() async{
    _database = await _repositoryBase.database;

    var TransacoesEntrada = await _database.rawQuery("SELECT IFNULL(SUM(T.VALOR), 0) AS TOTAL FROM TB_TRANSACAO AS T INNER JOIN TB_CATEGORIA AS C ON T.ID_CATEGORIA = C.ID WHERE C.ENTRADA = 1 AND T.FINALIZADO = 1");
    var TransacoesSaida = await _database.rawQuery("SELECT IFNULL(SUM(T.VALOR), 0) AS TOTAL FROM TB_TRANSACAO  AS T INNER JOIN TB_CATEGORIA AS C ON T.ID_CATEGORIA = C.ID WHERE C.ENTRADA = 0 AND T.FINALIZADO = 1");
    var TotalConta = await _database.rawQuery("SELECT IFNULL(VALOR, 0) AS VALOR FROM TB_CONTA WHERE CONTA_PADRAO = 1 LIMIT 1");

    var valorTotalEntrada = TransacoesEntrada[0]["TOTAL"].toString();
    var valorTotalSaida = TransacoesSaida[0]["TOTAL"].toString();
    var valorTotalConta = TotalConta[0]["VALOR"].toString();
    
    Decimal totalAtual = (Decimal.parse(valorTotalConta) + Decimal.parse(valorTotalEntrada)) - Decimal.parse(valorTotalSaida);

    return totalAtual;
  }

  Future<Decimal> _calcularValorTotalFechamento() async{
    _database = await _repositoryBase.database;

    var TransacoesEntrada = await _database.rawQuery("SELECT IFNULL(SUM(T.VALOR), 0) AS TOTAL FROM TB_TRANSACAO AS T INNER JOIN TB_CATEGORIA AS C ON T.ID_CATEGORIA = C.ID WHERE C.ENTRADA = 1 AND (T.FINALIZADO = 1 OR T.DATA < DATE())");
    var TransacoesSaida = await _database.rawQuery("SELECT IFNULL(SUM(T.VALOR), 0) AS TOTAL FROM TB_TRANSACAO  AS T INNER JOIN TB_CATEGORIA AS C ON T.ID_CATEGORIA = C.ID WHERE C.ENTRADA = 0 AND (T.FINALIZADO = 1 OR T.DATA < DATE())");
    var TotalConta = await _database.rawQuery("SELECT IFNULL(VALOR, 0) AS VALOR FROM TB_CONTA WHERE CONTA_PADRAO = 1 LIMIT 1");

    var  valorTotalEntrada = TransacoesEntrada[0]["TOTAL"].toString();
    var valorTotalSaida = TransacoesSaida[0]["TOTAL"].toString();
    var valorTotalConta = TotalConta[0]["VALOR"].toString();

    Decimal totalAtualFechamento = (Decimal.parse(valorTotalConta) + Decimal.parse(valorTotalEntrada)) - Decimal.parse(valorTotalSaida);

    return totalAtualFechamento;
  }

}