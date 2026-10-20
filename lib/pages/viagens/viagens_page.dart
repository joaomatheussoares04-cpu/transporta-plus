import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/viagem.dart';
import '../../providers/transporta_provider.dart';
import 'nova_viagem_page.dart';

class ViagensPage extends StatelessWidget {
  const ViagensPage({super.key});

  void _adicionarViagem(BuildContext context) async {
    final viagem = await Navigator.push<Viagem>(
      context,
      MaterialPageRoute(
        builder: (context) => const NovaViagemPage(),
      ),
    );

    if (viagem != null && context.mounted) {
      context.read<TransportaProvider>().adicionarViagem(viagem);
    }
  }

  void _excluirViagem(BuildContext context, int index) {
    context.read<TransportaProvider>().removerViagem(index);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Viagem excluída com sucesso.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viagens = context.watch<TransportaProvider>().viagens;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Viagens'),
      ),
      body: viagens.isEmpty
          ? const Center(
              child: Text(
                'Nenhuma viagem cadastrada.',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: viagens.length,
              itemBuilder: (context, index) {
                final viagem = viagens[index];

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade50,
                      child: Icon(
                        Icons.route,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    title: Text(
                      '${viagem.origem} → ${viagem.destino}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        'Motorista: ${viagem.motorista}\n'
                        'Veículo: ${viagem.veiculo}\n'
                        'Data: ${viagem.data}\n'
                        'Status: ${viagem.status}',
                      ),
                    ),
                    isThreeLine: true,
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'excluir') {
                          _excluirViagem(context, index);
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
        onPressed: () => _adicionarViagem(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}