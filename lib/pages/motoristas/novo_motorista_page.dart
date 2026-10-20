import 'package:flutter/material.dart';
import '../../models/motorista.dart';

class NovoMotoristaPage extends StatefulWidget {
  const NovoMotoristaPage({super.key});

  @override
  State<NovoMotoristaPage> createState() => _NovoMotoristaPageState();
}

class _NovoMotoristaPageState extends State<NovoMotoristaPage> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();
  final _cnhController = TextEditingController();
  final _telefoneController = TextEditingController();

  String categoriaSelecionada = 'D';

  @override
  void dispose() {
    _nomeController.dispose();
    _cpfController.dispose();
    _cnhController.dispose();
    _telefoneController.dispose();

    super.dispose();
  }

  void _salvarMotorista() {
    if (_formKey.currentState!.validate()) {
     final motorista = Motorista(
  nome: _nomeController.text,
  cpf: _cpfController.text,
  cnh: _cnhController.text,
  categoria: categoriaSelecionada,
  telefone: _telefoneController.text,
  status: 'Disponível',
);

Navigator.pop(context, motorista);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),

      appBar: AppBar(
        title: const Text(
          'Novo motorista',
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
                'Informações do motorista',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Preencha os dados para cadastrar um novo motorista.',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 25),

              TextFormField(
                controller: _nomeController,
                decoration: _inputDecoration(
                  label: 'Nome completo',
                  icon: Icons.person_outline,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o nome do motorista';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 18),

              TextFormField(
                controller: _cpfController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration(
                  label: 'CPF',
                  icon: Icons.badge_outlined,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o CPF';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 18),

              TextFormField(
                controller: _cnhController,
                keyboardType: TextInputType.number,
                decoration: _inputDecoration(
                  label: 'Número da CNH',
                  icon: Icons.credit_card_outlined,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o número da CNH';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 18),

              DropdownButtonFormField<String>(
                initialValue: categoriaSelecionada,
                decoration: _inputDecoration(
                  label: 'Categoria da CNH',
                  icon: Icons.directions_car_outlined,
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'A',
                    child: Text('Categoria A'),
                  ),
                  DropdownMenuItem(
                    value: 'B',
                    child: Text('Categoria B'),
                  ),
                  DropdownMenuItem(
                    value: 'C',
                    child: Text('Categoria C'),
                  ),
                  DropdownMenuItem(
                    value: 'D',
                    child: Text('Categoria D'),
                  ),
                  DropdownMenuItem(
                    value: 'E',
                    child: Text('Categoria E'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      categoriaSelecionada = value;
                    });
                  }
                },
              ),

              const SizedBox(height: 18),

              TextFormField(
                controller: _telefoneController,
                keyboardType: TextInputType.phone,
                decoration: _inputDecoration(
                  label: 'Telefone',
                  icon: Icons.phone_outlined,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Informe o telefone';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: _salvarMotorista,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text(
                    'SALVAR MOTORISTA',
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