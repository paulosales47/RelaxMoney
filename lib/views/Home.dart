import 'package:flutter/material.dart';
import 'package:relax_money/models/BalancoModel.dart';
import 'package:relax_money/models/TransacaoModel.dart';
import 'package:relax_money/service/BalancoService.dart';
import 'package:relax_money/service/TransacaoService.dart';
import 'package:relax_money/views/Balanco.dart';
import 'package:relax_money/views/Configuracoes.dart';
import 'package:relax_money/views/components/AlertNovaCategoria.dart';
import 'package:relax_money/views/components/AlertNovaConta.dart';
import 'package:relax_money/views/components/AlertTransacao.dart';
import 'package:unicorndial/unicorndial.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {

  TabController _tabController;
  var _transacaoService = TransacaoService();
  var _balancoService =BalancoService();
  List<TransacaoModel> _transacoes = [];
  var _balanco = BalancoModel.fromString("0", "0");

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _carregarInformacoesTela();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Relax Money"),
        bottom: TabBar(
          controller: _tabController,
          tabs: <Widget>[
            Tab(
              icon: Icon(Icons.compare_arrows),
            ),
            Tab(
              icon: Icon(Icons.settings),
            )
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Balanco(_transacoes, _balanco, _carregarInformacoesTela),
          Configuracoes(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: UnicornDialer(
        orientation: UnicornOrientation.VERTICAL,
        parentButton: Icon(Icons.add),
        childButtons: [
          UnicornButton(
            currentButton: FloatingActionButton(
              mini: true,
              child: Icon(Icons.compare_arrows),
              onPressed: () {
                _exibirAlertTransacao("Nova transação");
              },
            ),
          ),
          UnicornButton(
            currentButton: FloatingActionButton(
              mini: true,
              child: Icon(Icons.account_balance_wallet),
              onPressed: (){
                _exibirAlertNovaConta();
              },
            ),
          ),
          UnicornButton(
            currentButton: FloatingActionButton(
              mini: true,
              child: Icon(Icons.assignment),
              onPressed: () {
                _exibirAlertNovaCategoria();
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          height: 40,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          ),
        ),
        shape: CircularNotchedRectangle(),
      ),
    );
  }

  _exibirAlertTransacao(String titulo){
    showDialog(
        context: context,
        builder: (context){
          return AlertTransacao(titulo, (transacao) async{
            await _transacaoService.salvarTransacao(transacao).whenComplete((){
              setState(() {
                _carregarInformacoesTela();
              });
            });
          });
        }
    );
  }

  _exibirAlertNovaCategoria(){
    showDialog(
        context: context,
        builder: (context){
          return AlertNovaCategoria();
        }
    );
  }

  _exibirAlertNovaConta(){
    showDialog(
        context: context,
        builder: (context){
          return AlertNovaConta();
        }
    );
  }

  _carregarInformacoesTela() async {
    await _carregarBalanco().whenComplete(() async{
      await _carregarTransacoes().whenComplete((){
        setState(() {});
      });
    });
  }

  _carregarBalanco() async{
    _balanco = await _balancoService.carregarBalanco();
  }

  _carregarTransacoes() async{
    _transacoes = await _transacaoService.listarTransacoesMes();
  }



}
