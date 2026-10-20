
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/transporta_provider.dart';
import '../veiculos/veiculos_page.dart';
import '../motoristas/motoristas_page.dart';
import '../viagens/viagens_page.dart';
import '../manutencoes/manutencoes_page.dart';
import '../ocorrencias/ocorrencias_page.dart';
import '../perfil/perfil_page.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TransportaProvider>();

    final quantidadeVeiculos = provider.veiculos.length;
    final quantidadeMotoristas = provider.motoristas.length;
    final quantidadeViagens = provider.viagens.length;
    final quantidadeManutencoes = provider.manutencoes.length;
    final quantidadeOcorrencias = provider.ocorrencias.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Transporta+',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Olá, Administrador! 👋',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              'Confira as informações do transporte.',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 25),

            // Indicadores: Veículos e Motoristas.
            Row(
              children: [
                Expanded(
                  child: _buildInfoCard(
                    icon: Icons.local_shipping_outlined,
                    title: 'Veículos',
                    value: quantidadeVeiculos.toString(),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildInfoCard(
                    icon: Icons.person_outline,
                    title: 'Motoristas',
                    value: quantidadeMotoristas.toString(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // Indicadores: Viagens e Manutenções.
            Row(
              children: [
                Expanded(
                  child: _buildInfoCard(
                    icon: Icons.route_outlined,
                    title: 'Viagens',
                    value: quantidadeViagens.toString(),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildInfoCard(
                    icon: Icons.build_outlined,
                    title: 'Manutenções',
                    value: quantidadeManutencoes.toString(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // Indicador: Ocorrências.
            Row(
              children: [
                Expanded(
                  child: _buildInfoCard(
                    icon: Icons.warning_amber_outlined,
                    title: 'Ocorrências',
                    value: quantidadeOcorrencias.toString(),
                  ),
                ),
                const SizedBox(width: 15),
                const Expanded(
                  child: SizedBox(),
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              'Ações rápidas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),

            // Primeira linha de ações.
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.local_shipping_outlined,
                    title: 'Veículos',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const VeiculosPage(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.people_outline,
                    title: 'Motoristas',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MotoristasPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // Segunda linha de ações.
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.route_outlined,
                    title: 'Viagens',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ViagensPage(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.build_outlined,
                    title: 'Manutenções',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const ManutencoesPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // Terceira linha de ações.
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildActionButton(
                    icon: Icons.warning_amber_outlined,
                    title: 'Ocorrências',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const OcorrenciasPage(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 15),
                const Expanded(
                  child: SizedBox(),
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              'Viagens recentes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 15),

          

          
if (provider.viagens.isEmpty)
  Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: const Column(
      children: [
        Icon(
          Icons.route_outlined,
          size: 40,
          color: Colors.grey,
        ),
        SizedBox(height: 10),
        Text(
          'Nenhuma viagem cadastrada.',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    ),
  )
else
  ...provider.viagens.reversed.take(3).map((viagem) {
    final Color statusColor;

    switch (viagem.status.toLowerCase()) {
      case 'em andamento':
        statusColor = Colors.green;
        break;
      case 'finalizada':
        statusColor = Colors.grey;
        break;
      case 'agendada':
        statusColor = Colors.orange;
        break;
      default:
        statusColor = Colors.blue;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: _buildTripCard(
        origem: viagem.origem,
        destino: viagem.destino,
        motorista: viagem.motorista,
        status: viagem.status,
        statusColor: statusColor,
      ),
    );
  }),

          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1565C0),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const VeiculosPage(),
              ),
            );
          }

          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ViagensPage(),
              ),
            );
          }

          if (index == 3) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const PerfilPage(),
    ),
  );
}
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping_outlined),
            activeIcon: Icon(Icons.local_shipping),
            label: 'Veículos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.route_outlined),
            activeIcon: Icon(Icons.route),
            label: 'Viagens',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: const Color(0xFF1565C0),
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: const Color(0xFF1565C0),
            size: 30,
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripCard({
    required String origem,
    required String destino,
    required String motorista,
    required String status,
    required Color statusColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.route,
                color: Color(0xFF1565C0),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  '$origem → $destino',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.person_outline,
                size: 18,
                color: Colors.grey,
              ),
              const SizedBox(width: 6),
              Text(
                motorista,
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
