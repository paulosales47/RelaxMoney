import 'package:flutter/material.dart';
import 'package:relax_money/models/BalancoModel.dart';
import 'package:relax_money/models/TransacaoModel.dart';
import 'package:relax_money/views/components/FormatacaoTexto.dart';

class Balanco extends StatefulWidget {

  List<TransacaoModel> transacoes;
  BalancoModel balanco;

  Balanco(this.transacoes, this.balanco);

  @override
  _BalancoState createState() => _BalancoState();
}

class _BalancoState extends State<Balanco> {

  var _formatcao = FormatacaoTexto();


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
                return CheckboxListTile(
                  title: Text(widget.transacoes[index].descricao),
                  subtitle: Text("R\$: ${widget.transacoes[index].valor.toString()}"),
                  value: widget.transacoes[index].finalizado,
                  onChanged: (valor){
                    setState(() {
                      widget.transacoes[index].finalizado = valor;
                    });
                  });

                }),
          )
        ],
      ),
    );
  }
}
