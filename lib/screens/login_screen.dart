import 'package:flutter/material.dart';
import '../models/perfil_usuario.dart';
import 'dashboard_screen.dart';

enum LoginMode { entrar, cadastro, recuperar }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
          const SnackBar(content: Text('Instrucoes de recuperacao enviadas.')),
        );
        setState(() => _modo = LoginMode.entrar);
        return;
      }

      final perfil = _admin
          ? PerfilUsuario.administrador
          : PerfilUsuario.telespectador;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => DashboardScreen(perfil: perfil),
        ),
      );
    }
  }

  String get _titulo {
    switch (_modo) {
      case LoginMode.cadastro:
        return 'Criar conta';
      case LoginMode.recuperar:
        return 'Recuperar conta';
      case LoginMode.entrar:
        return 'Copa do Mundo 2026';
    }
  }

  String get _botaoPrincipal {
    switch (_modo) {
      case LoginMode.cadastro:
        return 'Cadastrar e entrar';
      case LoginMode.recuperar:
        return 'Enviar recuperacao';
      case LoginMode.entrar:
        return 'Entrar';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0B1F4D), Color(0xFF0B5FFF), Color(0xFFE61E4D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 430),
              padding: const EdgeInsets.all(28.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.16),
                    blurRadius: 24,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(
                      Icons.public,
                      size: 58,
                      color: Color(0xFF0B5FFF),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      _titulo,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0B1F4D),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _admin
                          ? 'Acesso administrativo para editar dados da copa.'
                          : 'Perfil telespectador para acompanhar a competicao.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 24),
                    if (_modo == LoginMode.cadastro) ...[
                      TextFormField(
                        controller: _nomeController,
                        decoration: const InputDecoration(
                          labelText: 'Nome',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.badge),
                        ),
                        validator: (value) {
                          if (_modo == LoginMode.cadastro &&
                              (value == null || value.isEmpty)) {
                            return 'Informe seu nome';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira seu e-mail';
                        }
                        return null;
                      },
                    ),
                    if (_modo != LoginMode.recuperar) ...[
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _senhaController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Senha',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.lock),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira sua senha';
                          }
                          return null;
                        },
                      ),
                    ],
                    const SizedBox(height: 18),
                    SegmentedButton<bool>(
                      segments: const [
                        ButtonSegment(
                          value: false,
                          label: Text('Telespectador'),
                          icon: Icon(Icons.visibility),
                        ),
                        ButtonSegment(
                          value: true,
                          label: Text('ADM'),
                          icon: Icon(Icons.admin_panel_settings),
                        ),
                      ],
                      selected: {_admin},
                      onSelectionChanged: (value) {
                        setState(() => _admin = value.first);
                      },
                    ),
                    const SizedBox(height: 24),
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
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 12,
                      children: [
                        TextButton(
                          onPressed: () => setState(() {
                            _modo = _modo == LoginMode.cadastro
                                ? LoginMode.entrar
                                : LoginMode.cadastro;
                          }),
                          child: Text(
                            _modo == LoginMode.cadastro
                                ? 'Ja tenho conta'
                                : 'Criar cadastro',
                          ),
                        ),
                        TextButton(
                          onPressed: () =>
                              setState(() => _modo = LoginMode.recuperar),
                          child: const Text('Recuperar conta'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
