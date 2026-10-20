
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/motorista.dart';

class MotoristaService {
  final CollectionReference<Map<String, dynamic>> _colecao =
      FirebaseFirestore.instance.collection('motoristas');

  Future<List<Motorista>> listarMotoristas() async {
    final consulta = await _colecao.get();

    return consulta.docs.map((documento) {
      final dados = documento.data();

      return Motorista(
        nome: dados['nome'] as String? ?? '',
        cpf: dados['cpf'] as String? ?? '',
        cnh: dados['cnh'] as String? ?? '',
        categoria: dados['categoria'] as String? ?? '',
        telefone: dados['telefone'] as String? ?? '',
        status: dados['status'] as String? ?? 'Disponível',
      );
    }).toList();
  }

  Future<void> salvarMotorista(Motorista motorista) async {
    await _colecao.doc(motorista.cnh).set({
      'nome': motorista.nome,
      'cpf': motorista.cpf,
      'cnh': motorista.cnh,
      'categoria': motorista.categoria,
      'telefone': motorista.telefone,
      'status': motorista.status,
    });
  }

  Future<void> removerMotorista(String cnh) async {
    await _colecao.doc(cnh).delete();
  }
}
