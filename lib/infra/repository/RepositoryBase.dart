import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class RepositoryBase{

  static final RepositoryBase _repositoryBase = RepositoryBase._internal();
  Database _database;

  Future<Database> get database async{
    if(_database != null)
      return await _database;

    _database = await _inicializarDatabase();
    return _database;


  }

  RepositoryBase._internal();

  factory RepositoryBase(){
    return _repositoryBase;
  }

  Future<Database> _inicializarDatabase() async{

    final caminhoBancoDados = await getDatabasesPath();
    final localBanco = join(caminhoBancoDados, "DB_RELAX_MONEY.db");

    var database = await openDatabase(
      localBanco,
      version: 1,
      onCreate: (database, version) async {
        await database.execute("CREATE TABLE TB_CATEGORIA (ID INTEGER PRIMARY KEY AUTOINCREMENT,  ICONE INTEGER, DESCRICAO VARCHAR, ENTRADA BOOLEAN)")
            .then((valor) async{
            await database.execute("CREATE TABLE TB_CONTA(ID INTEGER PRIMARY KEY AUTOINCREMENT,  VALOR DECIMAL(8,2), DESCRICAO VARCHAR, CONTA_PADRAO BOOLEAN)")
              .then((valor) async {
                await database.execute("CREATE TABLE TB_TRANSACAO (ID INTEGER PRIMARY KEY AUTOINCREMENT, DESCRICAO VARCHAR, VALOR DECIMAL(8,2), DATA DATETIME, FINALIZADO BOOLEAN, ID_CATEGORIA INTEGER, ID_CONTA INTEGER, FOREIGN KEY(ID_CATEGORIA) REFERENCES TB_CATEGORIA(ID), FOREIGN KEY(ID_CONTA) REFERENCES TB_CONTA(ID))")
                    .then((valor) async{
                  await database.execute("CREATE TABLE TB_CONFIGURACAO (ID INTEGER PRIMARY KEY AUTOINCREMENT, DIA_FECHAMENTO INTEGER)")
                      .then((valor) async{
                        await database.insert("TB_CATEGORIA", {"ICONE": 58672, "ENTRADA": false, "DESCRICAO": "TRANSPORTE" });
                        await database.insert("TB_CATEGORIA", {"ICONE": 57948, "ENTRADA": false, "DESCRICAO": "IMPOSTOS" });
                        await database.insert("TB_CATEGORIA", {"ICONE": 59553, "ENTRADA": false, "DESCRICAO": "FATURA CARTÃO" });
                        await database.insert("TB_CATEGORIA", {"ICONE": 59527, "ENTRADA": false, "DESCRICAO": "OUTROS" });
                        await database.insert("TB_CATEGORIA", {"ICONE": 57895, "ENTRADA": true, "DESCRICAO": "SALARIO" });
                        await database.insert("TB_CATEGORIA", {"ICONE": 57373, "ENTRADA": true, "DESCRICAO": "INVESTIMENTOS" });
                        await database.insert("TB_CATEGORIA", {"ICONE": 59527, "ENTRADA": true, "DESCRICAO": "OUTROS" });

                        await database.insert("TB_CONFIGURACAO", {"DIA_FECHAMENTO": 15});

                        await database.insert("TB_CONTA", {"DESCRICAO": "NuConta", "CONTA_PADRAO": true, "VALOR": 25321.12});
                        await database.insert("TB_CONTA", {"DESCRICAO": "EasyInvest", "CONTA_PADRAO": false, "VALOR": 369123.15});

                        await database.insert("TB_TRANSACAO", {"DESCRICAO": "Fatura cartão janeiro 2020", "VALOR": 2686.45, "DATA": DateTime.now().toString(), "FINALIZADO": false, "ID_CATEGORIA": 3, "ID_CONTA": 1});
                  });
                });
          });
        });
      }
    );

    return database;
  }




}