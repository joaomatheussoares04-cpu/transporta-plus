
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/manutencao.dart';
import '../../providers/transporta_provider.dart';

class ManutencoesPage extends StatelessWidget {
  const ManutencoesPage({super.key});

  void _adicionarManutencao(BuildContext context) async {
    final manutencao = await Navigator.push<Manutencao>(
      context,
      MaterialPageRoute(
        builder: (context) => const NovaManutencaoPage(),
      ),
    );

    if (manutencao != null && context.mounted) {
      context
          .read<TransportaProvider>()
          .adicionarManutencao(manutencao);
    }
  }

  void _excluirManutencao(BuildContext context, int index) {
    context.read<TransportaProvider>().removerManutencao(index);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Manutenção excluída com sucesso.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final manutencoes =
        context.watch<TransportaProvider>().manutencoes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manutenções'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
      body: manutencoes.isEmpty
          ? const Center(
              child: Text('Nenhuma manutenção cadastrada.'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: manutencoes.length,
              itemBuilder: (context, index) {
                final manutencao = manutencoes[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade50,
                      child: Icon(
                        Icons.build_outlined,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    title: Text(
                      manutencao.tipo,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Veículo: ${manutencao.veiculo}\n'
                        'Descrição: ${manutencao.descricao}\n'
                        'Data: ${manutencao.data}\n'
                        'Quilometragem: ${manutencao.quilometragem} km\n'
                        'Status: ${manutencao.status}',
                      ),
                    ),
                    isThreeLine: true,
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'excluir') {
                          _excluirManutencao(context, index);
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(
                          value: 'excluir',
                          child: Text('Excluir'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _adicionarManutencao(context),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NovaManutencaoPage extends StatefulWidget {
  const NovaManutencaoPage({super.key});

  @override
  State<NovaManutencaoPage> createState() =>
      _NovaManutencaoPageState();
}

class _NovaManutencaoPageState extends State<NovaManutencaoPage> {
  final _formKey = GlobalKey<FormState>();

  final _descricaoController = TextEditingController();
  final _quilometragemController = TextEditingController();

  String? veiculoSelecionado;
  String tipoSelecionado = 'Revisão preventiva';
  String statusSelecionado = 'Pendente';
  DateTime? dataSelecionada;

  final List<String> tipos = [
    'Revisão preventiva',
    'Troca de óleo',
    'Troca de pneus',
    'Reparo mecânico',
    'Reparo elétrico',
    'Outro',
  ];

  final List<String> statusDisponiveis = [
    'Pendente',
    'Em andamento',
    'Concluída',
  ];

  @override
  void dispose() {
    _descricaoController.dispose();
    _quilometragemController.dispose();
    super.dispose();
  }

  Future<void> _selecionarData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (data != null) {
      setState(() {
        dataSelecionada = data;
      });
    }
  }

  void _salvarManutencao() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (veiculoSelecionado == null) {
      _mensagem('Selecione um veículo.');
      return;
    }

    if (dataSelecionada == null) {
      _mensagem('Selecione a data da manutenção.');
      return;
    }

    final manutencao = Manutencao(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      veiculo: veiculoSelecionado!,
      tipo: tipoSelecionado,
      descricao: _descricaoController.text.trim(),
      data:
          '${dataSelecionada!.day.toString().padLeft(2, '0')}/'
          '${dataSelecionada!.month.toString().padLeft(2, '0')}/'
          '${dataSelecionada!.year}',
      quilometragem: _quilometragemController.text.trim(),
      status: statusSelecionado,
    );

    Navigator.pop(context, manutencao);
  }

  void _mensagem(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texto)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final veiculos = context.watch<TransportaProvider>().veiculos;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova manutenção'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            DropdownButtonFormField<String>(
              initialValue: veiculoSelecionado,
              decoration: const InputDecoration(
                labelText: 'Veículo',
                prefixIcon: Icon(Icons.local_shipping_outlined),
                border: OutlineInputBorder(),
              ),
              hint: const Text('Selecione um veículo'),
              items: veiculos.map((veiculo) {
                return DropdownMenuItem<String>(
                  value: veiculo.placa,
                  child: Text(
                    '${veiculo.modelo} - ${veiculo.placa}',
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  veiculoSelecionado = value;
                });
              },
              validator: (value) {
                if (value == null) {
                  return 'Selecione um veículo';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),
            DropdownButtonFormField<String>(
              initialValue: tipoSelecionado,
              decoration: const InputDecoration(
                labelText: 'Tipo de manutenção',
                prefixIcon: Icon(Icons.build_outlined),
                border: OutlineInputBorder(),
              ),
              items: tipos.map((tipo) {
                return DropdownMenuItem<String>(
                  value: tipo,
                  child: Text(tipo),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    tipoSelecionado = value;
                  });
                }
              },
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: _descricaoController,
              decoration: const InputDecoration(
                labelText: 'Descrição do serviço',
                prefixIcon: Icon(Icons.description_outlined),
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Informe a descrição.';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),
            TextFormField(
              controller: _quilometragemController,
              decoration: const InputDecoration(
                labelText: 'Quilometragem',
                suffixText: 'km',
                prefixIcon: Icon(Icons.speed),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Informe a quilometragem.';
                }
                if (int.tryParse(value.trim()) == null) {
                  return 'Informe um número inteiro válido.';
                }
                return null;
              },
            ),
            const SizedBox(height: 18),
            DropdownButtonFormField<String>(
              initialValue: statusSelecionado,
              decoration: const InputDecoration(
                labelText: 'Status',
                prefixIcon: Icon(Icons.flag_outlined),
                border: OutlineInputBorder(),
              ),
              items: statusDisponiveis.map((status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    statusSelecionado = value;
                  });
                }
              },
            ),
            const SizedBox(height: 18),
            OutlinedButton.icon(
              onPressed: _selecionarData,
              icon: const Icon(Icons.calendar_today),
              label: Text(
                dataSelecionada == null
                    ? 'Selecionar data'
                    : '${dataSelecionada!.day.toString().padLeft(2, '0')}/'
                        '${dataSelecionada!.month.toString().padLeft(2, '0')}/'
                        '${dataSelecionada!.year}',
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _salvarManutencao,
                icon: const Icon(Icons.save_outlined),
                label: const Text('CADASTRAR MANUTENÇÃO'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1565C0),
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
