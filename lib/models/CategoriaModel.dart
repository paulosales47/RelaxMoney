import 'package:flutter/cupertino.dart';

class CategoriaModel{
  int id;
  Icon icone;
  String descricao;
  bool entrada;

  CategoriaModel(this.icone, this.descricao, this.entrada, [this.id]);

  CategoriaModel.fromMap(Map<String, dynamic> mapCategoria){
    this.id = mapCategoria["ID"];
    this.icone = Icon(IconData(mapCategoria["ICONE"], fontFamily: 'MaterialIcons'));
    this.descricao = mapCategoria["DESCRICAO"];
    this.entrada = mapCategoria["ENTRADA"] == 1 ? true : false;
  }

}