
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/motorista.dart';
import '../../providers/transporta_provider.dart';
import 'novo_motorista_page.dart';

class MotoristasPage extends StatefulWidget {
  const MotoristasPage({super.key});

  @override
  State<MotoristasPage> createState() => _MotoristasPageState();
}

class _MotoristasPageState extends State<MotoristasPage> {
  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregarMotoristas();
  }

  Future<void> _carregarMotoristas() async {
    try {
      await context.read<TransportaProvider>().carregarMotoristas();

      if (!mounted) return;

      setState(() {
        _carregando = false;
        _erro = null;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _carregando = false;
        _erro = 'Não foi possível carregar os motoristas.';
      });
    }
  }

  Future<void> _adicionarMotorista() async {
    final motorista = await Navigator.push<Motorista>(
      context,
      MaterialPageRoute(
        builder: (context) => const NovoMotoristaPage(),
      ),
    );

    if (motorista == null || !mounted) return;

    try {
      await context
          .read<TransportaProvider>()
          .adicionarMotorista(motorista);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Motorista salvo com sucesso.'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível salvar o motorista.'),
        ),
      );
    }
  }

  Future<void> _excluirMotorista(int index) async {
    try {
      await context
          .read<TransportaProvider>()
          .removerMotorista(index);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Motorista excluído com sucesso.'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível excluir o motorista.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransportaProvider>();
    final motoristas = provider.motoristas;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Motoristas'),
      ),
      body: _carregando
          ? const Center(
              child: CircularProgressIndicator(),
            )
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
                          _carregarMotoristas();
                        },
                        child: const Text('Tentar novamente'),
                      ),
                    ],
                  ),
                )
              : motoristas.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhum motorista cadastrado.',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: motoristas.length,
                      itemBuilder: (context, index) {
                        final motorista = motoristas[index];

                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.blue.shade50,
                              child: Icon(
                                Icons.person,
                                color: Colors.blue.shade700,
                              ),
                            ),
                            title: Text(
                              motorista.nome,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                'CNH: ${motorista.cnh}\n'
                                'Categoria: ${motorista.categoria}\n'
                                'Telefone: ${motorista.telefone}',
                              ),
                            ),
                            isThreeLine: true,
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'excluir') {
                                  _excluirMotorista(index);
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
            : _adicionarMotorista,
        child: const Icon(Icons.add),
      ),
    );
  }
}
