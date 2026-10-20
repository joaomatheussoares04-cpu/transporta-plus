
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../home/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  bool senhaVisivel = false;
  bool carregando = false;

  Future<void> _entrar() async {
    final email = _emailController.text.trim();
    final senha = _senhaController.text;

    if (email.isEmpty || senha.isEmpty) {
      _mostrarMensagem('Preencha o e-mail e a senha.');
      return;
    }

    setState(() => carregando = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: senha,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String mensagem;

      switch (e.code) {
        case 'invalid-email':
          mensagem = 'O formato do e-mail é inválido.';
          break;
        case 'user-not-found':
        case 'invalid-credential':
        case 'wrong-password':
          mensagem = 'E-mail ou senha incorretos.';
          break;
        case 'user-disabled':
          mensagem = 'Esta conta está desativada.';
          break;
        case 'too-many-requests':
          mensagem = 'Muitas tentativas. Tente novamente mais tarde.';
          break;
        case 'network-request-failed':
          mensagem = 'Verifique sua conexão com a internet.';
          break;
        default:
          mensagem = 'Não foi possível entrar. Tente novamente.';
      }

      _mostrarMensagem(mensagem);
    } catch (e) {
      if (!mounted) return;
      _mostrarMensagem('Ocorreu um erro inesperado ao entrar.');
    } finally {
      if (mounted) {
        setState(() => carregando = false);
      }
    }
  }

  Future<void> _recuperarSenha() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      _mostrarMensagem('Digite seu e-mail para recuperar a senha.');
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
      );

      if (!mounted) return;

      _mostrarMensagem(
        'Se houver uma conta para esse e-mail, você receberá '
        'as instruções de recuperação.',
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      if (e.code == 'invalid-email') {
        _mostrarMensagem('O formato do e-mail é inválido.');
      } else {
        _mostrarMensagem(
          'Não foi possível solicitar a recuperação. Tente novamente.',
        );
      }
    } catch (e) {
      if (!mounted) return;
      _mostrarMensagem('Verifique sua conexão e tente novamente.');
    }
  }

  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(mensagem)),
      );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1565C0),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.local_shipping,
                    color: Colors.white,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'TRANSPORTA+',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1565C0),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Gestão de Transporte',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Bem-vindo!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Entre para acessar sua conta',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 25),
                      TextField(
                        controller: _emailController,
                        enabled: !carregando,
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.email],
                        decoration: InputDecoration(
                          labelText: 'E-mail',
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _senhaController,
                        enabled: !carregando,
                        obscureText: !senhaVisivel,
                        autofillHints: const [AutofillHints.password],
                        onSubmitted: (_) {
                          if (!carregando) _entrar();
                        },
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                senhaVisivel = !senhaVisivel;
                              });
                            },
                            icon: Icon(
                              senhaVisivel
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          onPressed: carregando ? null : _entrar,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1565C0),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: carregando
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'ENTRAR',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextButton(
                        onPressed:
                            carregando ? null : _recuperarSenha,
                        child: const Text('Esqueci minha senha'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
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
        ),
      ),
    );
  }
}
