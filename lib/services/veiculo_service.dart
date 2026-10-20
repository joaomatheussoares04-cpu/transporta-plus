
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/veiculo.dart';

class VeiculoService {
  final CollectionReference<Map<String, dynamic>> _colecao =
      FirebaseFirestore.instance.collection('veiculos');

  Future<List<Veiculo>> listarVeiculos() async {
    final consulta = await _colecao.get();

    return consulta.docs.map((documento) {
      final dados = documento.data();

      return Veiculo(
        placa: dados['placa'] as String? ?? '',
        marca: dados['marca'] as String? ?? '',
        modelo: dados['modelo'] as String? ?? '',
        ano: dados['ano'] as String? ?? '',
        quilometragem:
            dados['quilometragem'] as String? ?? '',
        status: dados['status'] as String? ?? 'Disponível',
      );
    }).toList();
  }

  Future<void> salvarVeiculo(Veiculo veiculo) async {
    await _colecao.doc(veiculo.placa).set({
      'placa': veiculo.placa,
      'marca': veiculo.marca,
      'modelo': veiculo.modelo,
      'ano': veiculo.ano,
      'quilometragem': veiculo.quilometragem,
      'status': veiculo.status,
    });
  }

  Future<void> removerVeiculo(String placa) async {
    await _colecao.doc(placa).delete();
  }
}
