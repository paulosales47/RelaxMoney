import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:relax_money/models/ContaModel.dart';
import 'package:relax_money/service/ContaService.dart';

class AlertConta extends StatefulWidget {

  Function callback;

  AlertConta(this.callback);

  @override
  _AlertContaState createState() => _AlertContaState();
}

class _AlertContaState extends State<AlertConta> {

  var _contaService = ContaService();
  List<ContaModel> _contas = [];
  ContaModel _contaSelecionada;
  var _controllerValor = TextEditingController();

  _carregarContas() async{
    _contas =  await _contaService.listarContas().whenComplete((){
      setState(() {});
    });
  }

  _atualizarConta() async{
    _contaSelecionada.valor = Decimal.parse(_controllerValor.text);
    await _contaService.atualizarConta(_contaSelecionada).whenComplete((){
      Navigator.pop(context);
      widget.callback();
    });
  }

  @override
  void initState() {
    super.initState();
    _carregarContas();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: DropdownButton(
                hint: Text("Selecione a conta"),
                value: _contaSelecionada,
                items: _contas.map((ContaModel conta){
                  return DropdownMenuItem(
                    value: conta,
                    child: Row(
                      children: <Widget>[
                        Text(conta.descricao)
                      ],
                    )
                  );
                }).toList(),
                onChanged: (ContaModel conta){
                  setState(() {
                    _contaSelecionada = conta;
                    _controllerValor.text = conta.valor.toString();
                  });
                }),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: TextFormField(
                controller: _controllerValor,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Informe o valor na conta"
                ),
              ),
            )
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
          child: Text("Cancelar"),
          onPressed: () => Navigator.pop(context),
        ),
        FlatButton(
          child: Text("Atualizar"),
          onPressed: _atualizarConta,
        )
      ],
    );
  }
}
