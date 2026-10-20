import 'package:flutter/foundation.dart';

import '../models/veiculo.dart';
import '../models/motorista.dart';
import '../models/viagem.dart';
import '../models/manutencao.dart';
import '../models/ocorrencia.dart';
import '../services/motorista_service.dart';


import '../services/veiculo_service.dart';


class TransportaProvider extends ChangeNotifier {
  

Future<void> carregarVeiculos() async {
  if (_veiculosCarregados) return;

  try {
    final veiculosSalvos =
        await _veiculoService.listarVeiculos();

    _veiculos
      ..clear()
      ..addAll(veiculosSalvos);

    _veiculosCarregados = true;
    notifyListeners();
  } catch (e) {
    debugPrint('Erro ao carregar veículos: $e');
    rethrow;
  }
}



  
final VeiculoService _veiculoService = VeiculoService();

bool _veiculosCarregados = false;
bool get veiculosCarregados => _veiculosCarregados;

final MotoristaService _motoristaService = MotoristaService();

bool _motoristasCarregados = false;
bool get motoristasCarregados => _motoristasCarregados;

Future<void> carregarMotoristas() async {
  if (_motoristasCarregados) return;

  try {
    final motoristasSalvos =
        await _motoristaService.listarMotoristas();

    _motoristas
      ..clear()
      ..addAll(motoristasSalvos);

    _motoristasCarregados = true;
    notifyListeners();
  } catch (e) {
    debugPrint('Erro ao carregar motoristas: $e');
    rethrow;
  }
}

  final List<Veiculo> _veiculos = [
    Veiculo(
      placa: 'ABC-1234',
      marca: 'Mercedes-Benz',
      modelo: 'Atego',
      ano: '2022',
      quilometragem: '85.420 km',
      status: 'Disponível',
    ),
    Veiculo(
      placa: 'DEF-5678',
      marca: 'Volvo',
      modelo: 'FH',
      ano: '2021',
      quilometragem: '120.350 km',
      status: 'Em viagem',
    ),
    Veiculo(
      placa: 'GHI-9012',
      marca: 'Fiat',
      modelo: 'Ducato',
      ano: '2023',
      quilometragem: '42.800 km',
      status: 'Manutenção',
    ),
  ];

  final List<Motorista> _motoristas = [
    Motorista(
      nome: 'João Silva',
      cpf: '123.456.789-00',
      cnh: '123456789',
      categoria: 'D',
      telefone: '(86) 99999-1111',
      status: 'Disponível',
    ),
    Motorista(
      nome: 'Carlos Santos',
      cpf: '987.654.321-00',
      cnh: '987654321',
      categoria: 'E',
      telefone: '(86) 98888-2222',
      status: 'Em viagem',
    ),
    Motorista(
      nome: 'Marcos Oliveira',
      cpf: '456.789.123-00',
      cnh: '456789123',
      categoria: 'D',
      telefone: '(86) 97777-3333',
      status: 'Disponível',
    ),
  ];

  final List<Viagem> _viagens = [
    Viagem(
      id: '001',
      origem: 'Teresina',
      destino: 'Parnaíba',
      motorista: 'João Silva',
      veiculo: 'ABC-1234',
      data: '07/10/2026',
      status: 'Em andamento',
    ),
    Viagem(
      id: '002',
      origem: 'Teresina',
      destino: 'Campo Maior',
      motorista: 'Carlos Santos',
      veiculo: 'DEF-5678',
      data: '08/10/2026',
      status: 'Agendada',
    ),
    Viagem(
      id: '003',
      origem: 'Teresina',
      destino: 'Picos',
      motorista: 'Marcos Oliveira',
      veiculo: 'GHI-9012',
      data: '05/10/2026',
      status: 'Finalizada',
    ),
  ];

  final List<Manutencao> _manutencoes = [
  Manutencao(
    id: '001',
    veiculo: 'DEF-5678',
    tipo: 'Troca de óleo',
    descricao: 'Troca de óleo do motor',
    data: '08/10/2026',
    quilometragem: '120350',
    status: 'Pendente',
  ),
  Manutencao(
    id: '002',
    veiculo: 'GHI-9012',
    tipo: 'Revisão preventiva',
    descricao: 'Revisão geral do veículo',
    data: '09/10/2026',
    quilometragem: '42800',
    status: 'Em andamento',
  ),
];

final List<Ocorrencia> _ocorrencias = [
  Ocorrencia(
    id: '001',
    veiculo: 'DEF-5678',
    tipo: 'Problema mecânico',
    descricao: 'Ruído identificado no motor durante a viagem.',
    data: '08/10/2026',
    local: 'Teresina - PI',
    status: 'Pendente',
  ),
  Ocorrencia(
    id: '002',
    veiculo: 'GHI-9012',
    tipo: 'Pneu danificado',
    descricao: 'Necessidade de verificar o pneu dianteiro.',
    data: '09/10/2026',
    local: 'Campo Maior - PI',
    status: 'Em andamento',
  ),
];

  List<Veiculo> get veiculos => List.unmodifiable(_veiculos);

  List<Motorista> get motoristas => List.unmodifiable(_motoristas);

  List<Viagem> get viagens => List.unmodifiable(_viagens);

  List<Manutencao> get manutencoes =>
    List.unmodifiable(_manutencoes);

    List<Ocorrencia> get ocorrencias =>
    List.unmodifiable(_ocorrencias);

  
  
  
Future<void> adicionarVeiculo(Veiculo veiculo) async {
  await _veiculoService.salvarVeiculo(veiculo);

  final index = _veiculos.indexWhere(
    (item) => item.placa == veiculo.placa,
  );

  if (index >= 0) {
    _veiculos[index] = veiculo;
  } else {
    _veiculos.add(veiculo);
  }

  notifyListeners();
}


  
Future<void> removerVeiculo(int index) async {
  final veiculo = _veiculos[index];

  await _veiculoService.removerVeiculo(veiculo.placa);

  _veiculos.removeAt(index);
  notifyListeners();
}


 Future<void> adicionarMotorista(Motorista motorista) async {
  await _motoristaService.salvarMotorista(motorista);

  final index = _motoristas.indexWhere(
    (item) => item.cnh == motorista.cnh,
  );

  if (index >= 0) {
    _motoristas[index] = motorista;
  } else {
    _motoristas.add(motorista);
  }

  notifyListeners();
}

Future<void> removerMotorista(int index) async {
  final motorista = _motoristas[index];

  await _motoristaService.removerMotorista(motorista.cnh);

  _motoristas.removeAt(index);
  notifyListeners();
}

  void adicionarViagem(Viagem viagem) {
    _viagens.add(viagem);
    notifyListeners();
  }

  void removerViagem(int index) {
    _viagens.removeAt(index);
    notifyListeners();
  }


  void adicionarManutencao(Manutencao manutencao) {
  _manutencoes.add(manutencao);
  notifyListeners();
}

void removerManutencao(int index) {
  _manutencoes.removeAt(index);
  notifyListeners();
}



void adicionarOcorrencia(Ocorrencia ocorrencia) {
  _ocorrencias.add(ocorrencia);
  notifyListeners();
}

void removerOcorrencia(int index) {
  _ocorrencias.removeAt(index);
  notifyListeners();
}
}