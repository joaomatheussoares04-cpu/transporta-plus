
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/veiculo.dart';
import '../../providers/transporta_provider.dart';
import 'novo_veiculo_page.dart';

class VeiculosPage extends StatefulWidget {
  const VeiculosPage({super.key});

  @override
  State<VeiculosPage> createState() => _VeiculosPageState();
}

class _VeiculosPageState extends State<VeiculosPage> {
  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregarVeiculos();
  }

  Future<void> _carregarVeiculos() async {
    try {
      await context.read<TransportaProvider>().carregarVeiculos();

      if (!mounted) return;

      setState(() {
        _carregando = false;
        _erro = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _carregando = false;
        _erro = 'Não foi possível carregar os veículos.';
      });
    }
  }

  Future<void> _adicionarVeiculo() async {
    final veiculo = await Navigator.push<Veiculo>(
      context,
      MaterialPageRoute(
        builder: (context) => const NovoVeiculoPage(),
      ),
    );

    if (veiculo == null || !mounted) return;

    try {
      await context.read<TransportaProvider>().adicionarVeiculo(veiculo);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veículo salvo com sucesso.'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível salvar o veículo.'),
        ),
      );
    }
  }

  Future<void> _excluirVeiculo(int index) async {
    try {
      await context.read<TransportaProvider>().removerVeiculo(index);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veículo excluído com sucesso.'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível excluir o veículo.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransportaProvider>();
    final veiculos = provider.veiculos;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Veículos'),
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator())
          : _erro != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_erro!),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _carregando = true;
                            _erro = null;
                          });
                          _carregarVeiculos();
                        },
                        child: const Text('Tentar novamente'),
                      ),
                    ],
                  ),
                )
              : veiculos.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhum veículo cadastrado.',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: veiculos.length,
                      itemBuilder: (context, index) {
                        final veiculo = veiculos[index];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue.shade50,
                              child: Icon(
                                Icons.local_shipping,
                                color: Colors.blue.shade700,
                              ),
                            ),
                            title: Text(
                              '${veiculo.marca} ${veiculo.modelo}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                'Placa: ${veiculo.placa}\n'
                                'Ano: ${veiculo.ano}\n'
                                'Quilometragem: ${veiculo.quilometragem}',
                              ),
                            ),
                            isThreeLine: true,
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'excluir') {
                                  _excluirVeiculo(index);
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
        onPressed: _carregando || _erro != null
            ? null
            : _adicionarVeiculo,
        child: const Icon(Icons.add),
      ),
    );
  }
}
