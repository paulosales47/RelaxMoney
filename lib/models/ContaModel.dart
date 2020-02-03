import 'package:decimal/decimal.dart';

class ContaModel{
  int id;
  double valor;
  String descricao;
  bool padrao;

  ContaModel(this.valor, this.descricao, this.padrao, [this.id]);

  ContaModel.fromMap(Map<String, dynamic> mapConta){
    this.id = mapConta["ID"];
    this.valor = mapConta["VALOR"];
    this.descricao = mapConta["DESCRICAO"];
    this.padrao = mapConta["CONTA_PADRAO"] == 1 ? true : false;
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> mapConta = {
      "DESCRICAO": this.descricao,
      "CONTA_PADRAO": this.padrao,
      "VALOR": this.valor.toString()
    };

    return mapConta;
  }

}