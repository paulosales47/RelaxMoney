import 'package:relax_money/infra/repository/BalancoRepository.dart';
import 'package:relax_money/models/BalancoModel.dart';

class BalancoService{

  var _balancoRepository = BalancoRepository();

  Future<BalancoModel> carregarBalanco() async{
    return await _balancoRepository.carregarBalanco();
  }

}