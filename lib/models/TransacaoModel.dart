import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:relax_money/models/CategoriaModel.dart';
import 'package:relax_money/models/ContaModel.dart';

class TransacaoModel{
  int id;
  String descricao;
  Decimal valor;
  DateTime data;
  CategoriaModel categoria;
  bool finalizado;
  ContaModel conta;

  TransacaoModel(String valor, this.data, this.categoria, this.finalizado,
      this.conta, this.descricao, [this.id]){
    this.valor = Decimal.parse(valor);
  }

  TransacaoModel.fromMap(Map<String, dynamic> mapTransacao){
    this.id = mapTransacao["ID"];
    this.descricao = mapTransacao["DESCRICAO"];
    this.valor = Decimal.parse(mapTransacao["VALOR"].toString());
    this.data = DateTime.parse(mapTransacao["DATA"]);
    this.finalizado = mapTransacao["FINALIZADO"] == 1 ? true : false;

    this.categoria = CategoriaModel(
      Icon(IconData(mapTransacao["ICONE"], fontFamily: 'MaterialIcons')),
      mapTransacao["DESCRICAO_CATEGORIA"],
      mapTransacao["ENTRADA"] == 1 ? true : false,
      mapTransacao["ID_CATEGORIA"]
    );

    this.conta = ContaModel(
      mapTransacao["VALOR_CONTA"],
      mapTransacao["DESCRICAO_CONTA"],
      mapTransacao["CONTA_PADRAO"] == 1 ? true : false,
      mapTransacao["ID_CONTA"]
    );
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> mapTransacao = {
      "DESCRICAO": this.descricao,
      "VALOR": this.valor.toString(),
      "DATA": this.data.toString(),
      "FINALIZADO": this.finalizado,
      "ID_CATEGORIA": this.categoria.id,
      "ID_CONTA": this.conta.id};

    return mapTransacao;
  }



}