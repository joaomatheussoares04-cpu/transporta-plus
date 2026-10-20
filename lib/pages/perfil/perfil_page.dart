
import 'package:flutter/material.dart';

class PerfilPage extends StatelessWidget {
  const PerfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Meu Perfil',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // Foto e identificação do usuário.
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Column(
                children: [
                  CircleAvatar(
                    radius: 45,
                    backgroundColor: Color(0xFFE3F2FD),
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Color(0xFF1565C0),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Administrador',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Gestor do sistema de transporte',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 12),
                  Chip(
                    avatar: Icon(
                      Icons.verified_user_outlined,
                      size: 18,
                      color: Color(0xFF1565C0),
                    ),
                    label: Text('Perfil administrativo'),
                    backgroundColor: Color(0xFFE3F2FD),
                    side: BorderSide.none,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Conta',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 12),

            _buildOption(
              icon: Icons.person_outline,
              title: 'Dados pessoais',
              subtitle: 'Visualizar informações da conta',
              onTap: () {
                _mostrarMensagem(
                  context,
                  'A edição dos dados pessoais será implementada depois.',
                );
              },
            ),

            _buildOption(
              icon: Icons.notifications_outlined,
              title: 'Notificações',
              subtitle: 'Configurações de avisos',
              onTap: () {
                _mostrarMensagem(
                  context,
                  'As configurações de notificações serão implementadas depois.',
                );
              },
            ),

            _buildOption(
              icon: Icons.settings_outlined,
              title: 'Configurações',
              subtitle: 'Preferências do aplicativo',
              onTap: () {
                _mostrarMensagem(
                  context,
                  'As configurações serão implementadas depois.',
                );
              },
            ),

            const SizedBox(height: 28),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Aplicativo',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 12),

            _buildOption(
              icon: Icons.info_outline,
              title: 'Sobre o Transporta+',
              subtitle: 'Informações sobre o sistema',
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'Transporta+',
                  applicationVersion: '1.0.0',
                  applicationLegalese:
                      'Sistema de gerenciamento de transporte.',
                );
              },
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                onPressed: () {
                  _mostrarMensagem(
                    context,
                    'A funcionalidade de sair será conectada à autenticação.',
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text('SAIR DA CONTA'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              'Transporta+ © 2026',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      color: Colors.white,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ),
        leading: CircleAvatar(
          backgroundColor: const Color(0xFFE3F2FD),
          child: Icon(
            icon,
            color: const Color(0xFF1565C0),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  void _mostrarMensagem(BuildContext context, String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensagem)),
    );
  }
}
