import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:relax_money/models/BalancoModel.dart';
import 'package:relax_money/models/TransacaoModel.dart';
import 'package:relax_money/service/TransacaoService.dart';
import 'package:relax_money/views/components/AlertConta.dart';
import 'package:relax_money/views/components/AlertTransacao.dart';
import 'package:relax_money/views/components/FormatacaoTexto.dart';

class Balanco extends StatefulWidget {

  List<TransacaoModel> transacoes;
  BalancoModel balanco;
  Function refresh;

  Balanco(this.transacoes, this.balanco, this.refresh);

  @override
  _BalancoState createState() => _BalancoState();
}

class _BalancoState extends State<Balanco> {

  var _formatcao = FormatacaoTexto();
  var _transacaoService = TransacaoService();

  _exibirAltertConta(){
    showDialog(
      context: context,
      builder: (context){
        return AlertConta((){
          widget.refresh();
        });
      }

    );
  }

  _verificarTipoTransacao(TransacaoModel transacao){
    if(transacao.categoria.entrada && transacao.finalizado)
      return Colors.green[400];
    else if(transacao.categoria.entrada && !transacao.finalizado)
      return Colors.green[200];
    else if(!transacao.categoria.entrada && transacao.finalizado)
      return Colors.red[400];

    return Colors.red[200];
  }

  _exibirAlertTransacao(TransacaoModel transacao) async{
    showDialog(
        context: context,
        builder: (context){
          return AlertTransacao("Atualizar Transação", (transacao) async {
            await _transacaoService.atualizarTransacao(transacao).whenComplete((){
              widget.refresh();
            });
          }, transacao);
        }
    );
  }

  String _formatarValor(Decimal valor){

    final formatador = new NumberFormat.currency(locale: "pt_BR", symbol: "R\$");
    return formatador.format(valor.toDouble());
  }

  String _formatarData(DateTime data){
    initializeDateFormatting('pt_BR');
    var formatador = DateFormat("dd-MM");
    String dataFormatada = formatador.format(data);
    return dataFormatada;
  }

  _formatarTextoBalanco(TransacaoModel transacao){
    return Row(
      children: <Widget>[
        Text(_formatarData(transacao.data), style: TextStyle(
          fontWeight: FontWeight.bold
        ),),
        Text(" - "),
        Text(transacao.descricao)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          Card(
            child: ListTile(
              title: Center(
                  child: Row(
                    children: <Widget>[
                      Text("Total Atual: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),),
                      Text(_formatarValor(widget.balanco.totalAtual))
                    ],
                  )
              ),
              subtitle:Center(
                  child: Row(
                    children: <Widget>[
                      Text("Total Fechamento: ",
                        style: TextStyle(
                          fontWeight: FontWeight.bold
                        ),),
                      Text(_formatarValor(widget.balanco.totalFechamento))
                    ],
                  )
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: (){
                      _exibirAltertConta();
                    },
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.transacoes.length,
              itemBuilder: (context, index){
                return Dismissible(
                  direction: DismissDirection.startToEnd,
                  background: Container(
                    color: Colors.red,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(left: 16),
                          child: Icon(Icons.delete, color: Colors.white,),
                        )
                      ],
                    ),
                  ),
                  onDismissed: (DismissDirection direcao) async {
                    await _transacaoService.removerTransacao(widget.transacoes[index]).whenComplete(() async {
                      await widget.refresh();
                    });
                  },
                  key: UniqueKey(),
                  child: Card(
                    color: _verificarTipoTransacao(widget.transacoes[index]),
                    child: ListTile(
                      title: _formatarTextoBalanco(widget.transacoes[index]),
                      subtitle: Text(_formatarValor(widget.transacoes[index].valor)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Checkbox(
                              value: widget.transacoes[index].finalizado,
                              onChanged: (valor) async {
                                widget.transacoes[index].finalizado = valor;
                                await _transacaoService.atualizarTransacao(widget.transacoes[index]).whenComplete(() async{
                                  await widget.refresh();
                                });
                              }),
                          IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () async {
                                await _exibirAlertTransacao(widget.transacoes[index]);
                              })
                        ],
                      ),
                    ),
                  )
                );
              }),
          )
        ],
      ),
    );
  }
}
