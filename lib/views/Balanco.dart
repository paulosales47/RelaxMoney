import 'package:flutter/material.dart';
import 'package:relax_money/models/BalancoModel.dart';
import 'package:relax_money/models/TransacaoModel.dart';
import 'package:relax_money/service/TransacaoService.dart';
import 'package:relax_money/views/components/AlertConta.dart';
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
    if(transacao.categoria.entrada)
      return Colors.green;
    return Colors.red;
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
                  child: Text(widget.balanco.totalAtual.toString())
              ),
              subtitle:Center(
                  child: Text(widget.balanco.totalFechamento.toString())
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
                  direction: DismissDirection.horizontal,
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
                  secondaryBackground: Container(
                    color: Colors.blue,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(right: 16),
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.check_box, color: Colors.white,),
                              Icon(Icons.check_box_outline_blank, color: Colors.white,),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  onDismissed: (DismissDirection direcao) async {
                    if(direcao == DismissDirection.startToEnd){
                      await _transacaoService.removerTransacao(widget.transacoes[index]).whenComplete(() async {
                        await widget.refresh();
                      });
                    }
                  },
                  key: UniqueKey(),
                  child: CheckboxListTile(
                    activeColor: _verificarTipoTransacao(widget.transacoes[index]),
                    title: Text(widget.transacoes[index].descricao),
                    subtitle: Text("R\$: ${widget.transacoes[index].valor.toString()}"),
                    value: widget.transacoes[index].finalizado,
                    onChanged: (valor) async {
                        widget.transacoes[index].finalizado = valor;
                        await _transacaoService.atualizarTransacao(widget.transacoes[index]).whenComplete(() async{
                          await widget.refresh();
                        });
                    }));

                }),
          )
        ],
      ),
    );
  }
}
