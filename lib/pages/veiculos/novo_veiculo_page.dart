import 'package:flutter/material.dart';

import '../../models/veiculo.dart';

class NovoVeiculoPage extends StatefulWidget {
  const NovoVeiculoPage({super.key});

  @override
  State<NovoVeiculoPage> createState() => _NovoVeiculoPageState();
}

class _NovoVeiculoPageState extends State<NovoVeiculoPage> {
  final _formKey = GlobalKey<FormState>();

  final _marcaController = TextEditingController();
  final _modeloController = TextEditingController();
  final _placaController = TextEditingController();
  final _anoController = TextEditingController();
  final _quilometragemController = TextEditingController();

  @override
  void dispose() {
    _marcaController.dispose();
    _modeloController.dispose();
    _placaController.dispose();
    _anoController.dispose();
    _quilometragemController.dispose();

    super.dispose();
  }

  void _salvarVeiculo() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final veiculo = Veiculo(
      marca: _marcaController.text,
      modelo: _modeloController.text,
      placa: _placaController.text,
      ano: _anoController.text,
      quilometragem: _quilometragemController.text,
      status: 'Disponível',
    );

    Navigator.pop(context, veiculo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Veículo'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextFormField(
                controller: _marcaController,
                decoration: const InputDecoration(
                  labelText: 'Marca',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.business),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe a marca.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _modeloController,
                decoration: const InputDecoration(
                  labelText: 'Modelo',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.local_shipping),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o modelo.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _placaController,
                decoration: const InputDecoration(
                  labelText: 'Placa',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.confirmation_number),
                ),
                textCapitalization: TextCapitalization.characters,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe a placa.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _anoController,
                decoration: const InputDecoration(
                  labelText: 'Ano',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o ano.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: _quilometragemController,
                decoration: const InputDecoration(
                  labelText: 'Quilometragem',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.speed),
                  suffixText: 'km',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe a quilometragem.';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: _salvarVeiculo,
                  icon: const Icon(Icons.save),
                  label: const Text('Cadastrar Veículo'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}