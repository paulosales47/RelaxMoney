import 'package:decimal/decimal.dart';

class BalancoModel{
  Decimal totalAtual;
  Decimal totalFechamento;

  BalancoModel.fromString(String totalAtual, String totalFechamento){
    this.totalAtual = Decimal.parse(totalAtual);
    this.totalFechamento = Decimal.parse(totalFechamento);
  }

  BalancoModel(this.totalAtual, this.totalFechamento);
}