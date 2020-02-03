import 'package:flutter/material.dart';
import 'package:flutter/src/material/date_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:relax_money/models/CategoriaModel.dart';
import 'package:relax_money/models/ContaModel.dart';
import 'package:relax_money/models/TransacaoModel.dart';
import 'package:relax_money/service/CategoriaService.dart';
import 'package:relax_money/service/ContaService.dart';
import 'package:relax_money/service/TransacaoService.dart';

class AlertTransacao extends StatefulWidget {

  String titulo;
  Function(TransacaoModel) callback;

  AlertTransacao(this.titulo, this.callback){
  }

  @override
  _AlertTransacaoState  createState() => _AlertTransacaoState();
}

class _AlertTransacaoState extends State<AlertTransacao> {

  var _descricaoController = TextEditingController();
  var _valorController = TextEditingController();
  var _textodataTransacao = TextEditingController();
  DateTime _dataTransacao;
  bool _statusTransacao = false;
  var _categoriaService = CategoriaService();
  var _contaService = ContaService();
  var _transacaoService = TransacaoService();
  List<CategoriaModel> _categorias = [];
  List<ContaModel> _contas = [];
  ContaModel _contaSelecionada;
  CategoriaModel _categoriaSelecionada;



  _carregarContas() async{
    _contas = await _contaService.listarContas();
  }

  _carregarCategorias() async{
    _categorias = await _categoriaService.listarCategorias().whenComplete((){
      setState(() {});
    });
  }

  Future _selecionarData(BuildContext context) async {
    int anoAtual = DateTime.now().year;

    DateTime dataSelecionada = await showDatePicker(
      context: context,
      initialDate: new DateTime.now(),
      firstDate: new DateTime(anoAtual - 1),
      lastDate: new DateTime(anoAtual + 1),

    );

    if(dataSelecionada != null){
      _dataTransacao = dataSelecionada;
      _textodataTransacao.text = _formatarData(dataSelecionada);
    }

  }

  String _formatarData(DateTime data){
    initializeDateFormatting('pt_BR');
    var formatador = DateFormat.yMMMMd("pt_BR");
    String dataFormatada = formatador.format(data);
    return dataFormatada;
  }

  @override
  void initState() {
    super.initState();
    _carregarCategorias();
    _carregarContas();
  }

  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: Text(widget.titulo),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: TextFormField(
                keyboardType: TextInputType.text,
                maxLength: 20,
                controller: _descricaoController,
                decoration: InputDecoration(
                  labelText: "Informe a descrição da transação",
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: TextFormField(
                keyboardType: TextInputType.number,
                maxLength: 10,
                controller: _valorController,
                decoration: InputDecoration(
                  labelText: "Informe o valor",
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: TextFormField(
                keyboardType: TextInputType.number,
                readOnly: true,
                controller: _textodataTransacao,
                onTap: () => _selecionarData(context),
                decoration: InputDecoration(
                  labelText: "Informe a data",
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: DropdownButton(
                  hint: Text("Selecione uma categoria"),
                  value: _categoriaSelecionada,
                  items: _categorias.map((CategoriaModel categoria){
                    return DropdownMenuItem<CategoriaModel>(
                        value: categoria,
                        child: Row(children: <Widget>[
                          categoria.icone,
                          Text(categoria.descricao)
                        ],
                        ));
                  }).toList(),
                  onChanged: (categoria){
                    setState(() {
                      _categoriaSelecionada = categoria;
                    });
                  }
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: DropdownButton(
                  hint: Text("Selecione uma conta"),
                  value: _contaSelecionada,
                  items: _contas.map((ContaModel conta){
                    return DropdownMenuItem<ContaModel>(
                        value: conta,
                        child: Row(children: <Widget>[
                          Text(conta.descricao)
                        ],
                        ));
                  }).toList(),
                  onChanged: (conta){
                    setState(() {
                      _contaSelecionada = conta;
                    });
                  }
              ),
            ),
            SwitchListTile(
                title: Text("Transação finalizada"),
                value:  _statusTransacao,
                activeColor: Colors.blue,
                onChanged: (bool status){
                  setState(() {
                    _statusTransacao = status;
                  });
                }
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
          child: Text(widget.titulo),
          onPressed: () {

            var transacao = TransacaoModel(
              _valorController.text,
              _dataTransacao,
              _categoriaSelecionada,
              _statusTransacao,
              _contaSelecionada,
              _descricaoController.text,
            );

            widget.callback(transacao);
            Navigator.pop(context);
          },
        )
      ],
    );
  }
}
