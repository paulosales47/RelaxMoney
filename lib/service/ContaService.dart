import 'package:relax_money/infra/repository/ContaRepository.dart';

class ContaService{

  var _contaRepository = ContaRepository();

  listarContas() async{
    return await _contaRepository.listaContas();
  }

}