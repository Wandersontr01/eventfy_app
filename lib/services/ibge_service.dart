import 'package:http/http.dart' as http;
import 'dart:convert';

class IbgeService {
  // Singleton opcional (boa prática se quiser manter instância única)
  static final IbgeService _instance = IbgeService._internal();

  factory IbgeService() => _instance;

  IbgeService._internal();

  /// Busca os municípios de um estado (UF) via API do IBGE
  Future<List<String>> buscarMunicipiosPorEstado(String uf) async {
    try {
      final response = await http.get(
        Uri.parse('https://servicodados.ibge.gov.br/api/v1/localidades/estados/$uf/distritos'),
      );

      if (response.statusCode != 200) {
        throw Exception('Erro ao buscar cidades: ${response.statusCode}');
      }

      final List<dynamic> data = json.decode(response.body);
      final Set<String> municipios = data
          .map<String>((item) => item['municipio']['nome'] as String)
          .toSet(); // evitar duplicatas

      final listaOrdenada = municipios.toList()..sort();

      return listaOrdenada;
    } catch (e) {
      throw Exception('Erro na API IBGE: ${e.toString()}');
    }
  }
}
