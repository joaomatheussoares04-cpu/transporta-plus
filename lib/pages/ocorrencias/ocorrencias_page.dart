
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/ocorrencia.dart';
import '../../providers/transporta_provider.dart';

class OcorrenciasPage extends StatelessWidget {
  const OcorrenciasPage({super.key});

  void _adicionarOcorrencia(BuildContext context) async {
    final ocorrencia = await Navigator.push<Ocorrencia>(
      context,
      MaterialPageRoute(
        builder: (context) => const NovaOcorrenciaPage(),
      ),
    );

    if (ocorrencia != null && context.mounted) {
      context.read<TransportaProvider>().adicionarOcorrencia(
            ocorrencia,
          );
    }
  }

  void _excluirOcorrencia(BuildContext context, int index) {
    context.read<TransportaProvider>().removerOcorrencia(index);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ocorrência excluída com sucesso.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ocorrencias =
        context.watch<TransportaProvider>().ocorrencias;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ocorrências'),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),
      body: ocorrencias.isEmpty
          ? const Center(
              child: Text('Nenhuma ocorrência registrada.'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: ocorrencias.length,
              itemBuilder: (context, index) {
                final ocorrencia = ocorrencias[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: CircleAvatar(
                      backgroundColor: Colors.orange.shade50,
                      child: Icon(
                        Icons.warning_amber_outlined,
                        color: Colors.orange.shade800,
                      ),
                    ),
                    title: Text(
                      ocorrencia.tipo,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Veículo: ${ocorrencia.veiculo}\n'
                        'Descrição: ${ocorrencia.descricao}\n'
                        'Data: ${ocorrencia.data}\n'
                        'Local: ${ocorrencia.local}\n'
                        'Status: ${ocorrencia.status}',
                      ),
                    ),
                    isThreeLine: true,
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'excluir') {
                          _excluirOcorrencia(context, index);
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
        onPressed: () => _adicionarOcorrencia(context),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class NovaOcorrenciaPage extends StatefulWidget {
  const NovaOcorrenciaPage({super.key});

  @override
  State<NovaOcorrenciaPage> createState() =>
      _NovaOcorrenciaPageState();
}

class _NovaOcorrenciaPageState extends State<NovaOcorrenciaPage> {
  final _formKey = GlobalKey<FormState>();

  final _descricaoController = TextEditingController();
  final _localController = TextEditingController();

  String? veiculoSelecionado;
  String tipoSelecionado = 'Problema mecânico';
  String statusSelecionado = 'Pendente';
  DateTime? dataSelecionada;

  final List<String> tipos = [
    'Problema mecânico',
    'Acidente',
    'Pneu danificado',
    'Atraso na viagem',
    'Problema elétrico',
    'Outro',
  ];

  final List<String> statusDisponiveis = [
    'Pendente',
    'Em andamento',
    'Resolvida',
  ];

  @override
  void dispose() {
    _descricaoController.dispose();
    _localController.dispose();
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

  void _salvarOcorrencia() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (veiculoSelecionado == null) {
      _mostrarMensagem('Selecione um veículo.');
      return;
    }

    if (dataSelecionada == null) {
      _mostrarMensagem('Selecione a data da ocorrência.');
      return;
    }

    final ocorrencia = Ocorrencia(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      veiculo: veiculoSelecionado!,
      tipo: tipoSelecionado,
      descricao: _descricaoController.text.trim(),
      data:
          '${dataSelecionada!.day.toString().padLeft(2, '0')}/'
          '${dataSelecionada!.month.toString().padLeft(2, '0')}/'
          '${dataSelecionada!.year}',
      local: _localController.text.trim(),
      status: statusSelecionado,
    );

    Navigator.pop(context, ocorrencia);
  }

  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final veiculos = context.watch<TransportaProvider>().veiculos;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova ocorrência'),
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
                labelText: 'Tipo de ocorrência',
                prefixIcon: Icon(Icons.warning_amber_outlined),
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
                labelText: 'Descrição da ocorrência',
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
              controller: _localController,
              decoration: const InputDecoration(
                labelText: 'Local da ocorrência',
                prefixIcon: Icon(Icons.location_on_outlined),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Informe o local.';
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
                onPressed: _salvarOcorrencia,
                icon: const Icon(Icons.save_outlined),
                label: const Text('REGISTRAR OCORRÊNCIA'),
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
