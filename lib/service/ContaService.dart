import 'package:relax_money/infra/repository/ContaRepository.dart';
import 'package:relax_money/models/ContaModel.dart';

class ContaService{

  var _contaRepository = ContaRepository();

  listarContas() async{
    return await _contaRepository.listaContas();
  }

  atualizarConta(ContaModel conta) async{
    await _contaRepository.atualizarConta(conta);
  }

}