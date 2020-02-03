import 'package:relax_money/infra/repository/CategoriaRepository.dart';
import 'package:relax_money/models/CategoriaModel.dart';

class CategoriaService{

  var _categoriaRepository = CategoriaRepository();

  Future<List<CategoriaModel>> listarCategorias() async{
    return await _categoriaRepository.listarCategorias();
  }
}