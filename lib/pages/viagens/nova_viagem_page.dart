import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/viagem.dart';
import '../../providers/transporta_provider.dart';

class NovaViagemPage extends StatefulWidget {
  const NovaViagemPage({super.key});

  @override
  State<NovaViagemPage> createState() => _NovaViagemPageState();
}

class _NovaViagemPageState extends State<NovaViagemPage> {
  final _formKey = GlobalKey<FormState>();

  final _origemController = TextEditingController();
  final _destinoController = TextEditingController();

  String? motoristaSelecionado;
  String? veiculoSelecionado;

  DateTime? dataSelecionada;

  @override
  void dispose() {
    _origemController.dispose();
    _destinoController.dispose();

    super.dispose();
  }

  Future<void> _selecionarData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (data != null) {
      setState(() {
        dataSelecionada = data;
      });
    }
  }

  void _salvarViagem() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (motoristaSelecionado == null) {
      _mostrarMensagem('Selecione um motorista.');
      return;
    }

    if (veiculoSelecionado == null) {
      _mostrarMensagem('Selecione um veículo.');
      return;
    }

    if (dataSelecionada == null) {
      _mostrarMensagem('Selecione a data da viagem.');
      return;
    }

    final viagem = Viagem(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      origem: _origemController.text.trim(),
      destino: _destinoController.text.trim(),
      motorista: motoristaSelecionado!,
      veiculo: veiculoSelecionado!,
      data:
          '${dataSelecionada!.day.toString().padLeft(2, '0')}/'
          '${dataSelecionada!.month.toString().padLeft(2, '0')}/'
          '${dataSelecionada!.year}',
      status: 'Agendada',
    );

    Navigator.pop(context, viagem);
  }

  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransportaProvider>();

    final motoristas = provider.motoristas;
    final veiculos = provider.veiculos;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        title: const Text(
          'Nova viagem',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Informações da viagem',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Preencha os dados para criar uma nova viagem.',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 25),

              TextFormField(
                controller: _origemController,
                decoration: _inputDecoration(
                  label: 'Origem',
                  icon: Icons.location_on_outlined,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe a origem';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 18),

              TextFormField(
                controller: _destinoController,
                decoration: _inputDecoration(
                  label: 'Destino',
                  icon: Icons.flag_outlined,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o destino';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 18),

              DropdownButtonFormField<String>(
                initialValue: motoristaSelecionado,
                decoration: _inputDecoration(
                  label: 'Motorista',
                  icon: Icons.person_outline,
                ),
                hint: const Text('Selecione um motorista'),
                items: motoristas.map((motorista) {
                  return DropdownMenuItem<String>(
                    value: motorista.nome,
                    child: Text(motorista.nome),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    motoristaSelecionado = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecione um motorista';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 18),

              DropdownButtonFormField<String>(
                initialValue: veiculoSelecionado,
                decoration: _inputDecoration(
                  label: 'Veículo',
                  icon: Icons.local_shipping_outlined,
                ),
                hint: const Text('Selecione um veículo'),
                items: veiculos.map((veiculo) {
                  return DropdownMenuItem<String>(
                    value: veiculo.placa,
                    child: Text(
                      '${veiculo.marca} ${veiculo.modelo} - ${veiculo.placa}',
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    veiculoSelecionado = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecione um veículo';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 18),

              InkWell(
                onTap: _selecionarData,
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: _inputDecoration(
                    label: 'Data da viagem',
                    icon: Icons.calendar_today_outlined,
                  ),
                  child: Text(
                    dataSelecionada == null
                        ? 'Selecione uma data'
                        : '${dataSelecionada!.day.toString().padLeft(2, '0')}/'
                            '${dataSelecionada!.month.toString().padLeft(2, '0')}/'
                            '${dataSelecionada!.year}',
                    style: TextStyle(
                      color: dataSelecionada == null
                          ? Colors.grey
                          : Colors.black,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _salvarViagem,
                  icon: const Icon(Icons.route_outlined),
                  label: const Text(
                    'CRIAR VIAGEM',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1565C0),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }
}