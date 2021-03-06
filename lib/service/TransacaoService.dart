import 'package:relax_money/infra/repository/TransacaoRepository.dart';
import 'package:relax_money/models/TransacaoModel.dart';

class TransacaoService{

  var _transacaoRepository = TransacaoRepository();

  Future<List<TransacaoModel>> listarTransacoesMes() async{
    return await _transacaoRepository.listarTransacoesMes();
  }

  salvarTransacao(TransacaoModel transacao) async{
    return await _transacaoRepository.salvarTransacao(transacao);
  }

  removerTransacao(TransacaoModel transacao) async{
    await _transacaoRepository.removerTransacao(transacao);
  }

  atualizarTransacao(TransacaoModel transacao) async{
    await _transacaoRepository.atualizarTransacao(transacao);
  }


}