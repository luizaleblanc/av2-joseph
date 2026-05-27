import 'package:flutter/material.dart';
import '../domain/perfil_usuario.dart';
import '../../dashboard/presentation/dashboard_screen.dart';

enum LoginMode { entrar, cadastro, recuperar }

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginScreenContent();
  }
}

class LoginScreenContent extends StatefulWidget {
  const LoginScreenContent({super.key});

  @override
  State<LoginScreenContent> createState() => _LoginScreenContentState();
}

class _LoginScreenContentState extends State<LoginScreenContent> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _nomeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  LoginMode _modo = LoginMode.entrar;
  bool _admin = false;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    _nomeController.dispose();
    super.dispose();
  }

  void _fazerLogin() {
    if (_formKey.currentState!.validate()) {
      if (_modo == LoginMode.recuperar) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Instruções de recuperação enviadas.')),
        );
        setState(() => _modo = LoginMode.entrar);
        return;
      }

      final perfil = _admin ? PerfilUsuario.administrador : PerfilUsuario.telespectador;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardScreen(perfil: perfil),
        ),
      );
    }
  }

  String get _botaoPrincipal {
    switch (_modo) {
      case LoginMode.cadastro: return 'Cadastrar e entrar';
      case LoginMode.recuperar: return 'Enviar recuperação';
      case LoginMode.entrar: return 'Entrar';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1F4D),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 430),
            padding: const EdgeInsets.all(32.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    'assets/copa2026_poster.jpg',
                    height: 180,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.broken_image,
                      size: 64,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (_modo == LoginMode.cadastro) ...[
                    TextFormField(
                      controller: _nomeController,
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.badge_outlined),
                      ),
                      validator: (v) => _modo == LoginMode.cadastro && (v == null || v.isEmpty) ? 'Informe o seu nome' : null,
                    ),
                    const SizedBox(height: 16),
                  ],
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Informe o seu e-mail' : null,
                  ),
                  if (_modo != LoginMode.recuperar) ...[
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _senhaController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Senha',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      validator: (v) => v == null || v.isEmpty ? 'Informe a sua senha' : null,
                    ),
                  ],
                  if (_modo == LoginMode.cadastro) ...[
                    const SizedBox(height: 16),
                    SegmentedButton<bool>(
                      segments: const [
                        ButtonSegment(
                          value: false,
                          label: Text('Telespectador', style: TextStyle(fontSize: 12)),
                          icon: Icon(Icons.check, size: 16),
                        ),
                        ButtonSegment(
                          value: true,
                          label: Text('ADM', style: TextStyle(fontSize: 12)),
                          icon: Icon(Icons.admin_panel_settings, size: 16),
                        ),
                      ],
                      selected: {_admin},
                      onSelectionChanged: (v) => setState(() => _admin = v.first),
                      style: SegmentedButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _fazerLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE61E4D),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      _botaoPrincipal,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 12,
                    children: [
                      TextButton(
                        onPressed: () => setState(() => _modo = _modo == LoginMode.cadastro ? LoginMode.entrar : LoginMode.cadastro),
                        style: TextButton.styleFrom(foregroundColor: Colors.grey[600]),
                        child: Text(_modo == LoginMode.cadastro ? 'Já tenho conta' : 'Criar cadastro', style: const TextStyle(fontSize: 13)),
                      ),
                      TextButton(
                        onPressed: () => setState(() => _modo = LoginMode.recuperar),
                        style: TextButton.styleFrom(foregroundColor: Colors.grey[600]),
                        child: const Text('Recuperar conta', style: TextStyle(fontSize: 13)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
