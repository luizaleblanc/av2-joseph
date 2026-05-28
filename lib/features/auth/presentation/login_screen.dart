import 'package:flutter/material.dart';
import '../../../core/network/api_service.dart';
import '../../../core/widgets/copa_banner_header.dart';
import '../../../core/widgets/theme_mode_button.dart';
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
  static const _perguntaSeguranca =
      'Pergunta de segurança: Qual era o nome da sua professora favorita do ensino fundamental?';

  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _nomeController = TextEditingController();
  final _respostaSegurancaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _apiService = ApiService();

  LoginMode _modo = LoginMode.entrar;
  bool _salvando = false;
  String? _erroLogin;
  String? _erroRecuperacao;

  void _limparErroLogin() {
    if (_erroLogin != null || _erroRecuperacao != null) {
      setState(() {
        _erroLogin = null;
        _erroRecuperacao = null;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    _nomeController.dispose();
    _respostaSegurancaController.dispose();
    super.dispose();
  }

  Future<void> _fazerLogin() async {
    if (_formKey.currentState!.validate()) {
      if (_modo == LoginMode.recuperar) {
        setState(() => _salvando = true);

        final sucesso = await _apiService.validarRecuperacao(
          email: _emailController.text.trim(),
          perguntaSeguranca: _perguntaSeguranca,
          respostaSeguranca: _respostaSegurancaController.text.trim(),
        );

        if (!mounted) return;
        setState(() => _salvando = false);

        if (sucesso) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Instruções de recuperação enviadas.'),
            ),
          );
          setState(() => _modo = LoginMode.entrar);
        } else {
          setState(
            () => _erroRecuperacao =
                'Email ou resposta de segurança incorretos.',
          );
          _formKey.currentState?.validate();
        }
        return;
      }

      if (_modo == LoginMode.cadastro) {
        setState(() => _salvando = true);

        final sucesso = await _apiService.cadastrarUsuario(
          nome: _nomeController.text.trim(),
          email: _emailController.text.trim(),
          senha: _senhaController.text,
          perguntaSeguranca: _perguntaSeguranca,
          respostaSeguranca: _respostaSegurancaController.text.trim(),
        );

        if (!mounted) return;
        setState(() => _salvando = false);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              sucesso
                  ? 'Usuário cadastrado com sucesso!'
                  : 'Erro ao cadastrar. Verifique os dados ou tente outro e-mail.',
            ),
          ),
        );

        if (!sucesso) return;
      }

      if (_modo == LoginMode.entrar) {
        setState(() => _salvando = true);

        final sucesso = await _apiService.loginUsuario(
          email: _emailController.text.trim(),
          senha: _senhaController.text,
        );

        if (!mounted) return;
        setState(() => _salvando = false);

        if (!sucesso) {
          setState(() => _erroLogin = 'E-mail ou senha incorretos.');
          _formKey.currentState?.validate();
          return;
        }
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const DashboardScreen(),
        ),
      );
    }
  }

  String get _botaoPrincipal {
    switch (_modo) {
      case LoginMode.cadastro:
        return 'Cadastrar e entrar';
      case LoginMode.recuperar:
        return 'Enviar recuperação';
      case LoginMode.entrar:
        return 'Entrar';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final linkColor = isDark ? const Color(0xFFD7E3FF) : Colors.grey[600];

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xFF061B49)
          : const Color(0xFF0B1F4D),
      body: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).padding.top > 0
                ? MediaQuery.of(context).padding.top + 8
                : 16,
            right: 16,
            child: const HeaderCircleIconButton(
              child: ThemeModeButton(),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 430),
                padding: const EdgeInsets.all(32.0),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF142B5F) : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
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
                      validator: (v) =>
                          _modo == LoginMode.cadastro &&
                              (v == null || v.isEmpty)
                          ? 'Informe o seu nome'
                          : null,
                    ),
                    const SizedBox(height: 16),
                  ],
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (_) => _limparErroLogin(),
                    decoration: const InputDecoration(
                      labelText: 'E-mail',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return 'Informe o seu e-mail';
                      }
                      if (_modo == LoginMode.entrar && _erroLogin != null) {
                        return ' ';
                      }
                      if (_modo == LoginMode.recuperar &&
                          _erroRecuperacao != null) {
                        return ' ';
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
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      onChanged: (_) => _limparErroLogin(),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Informe a sua senha';
                        }
                        if (_modo == LoginMode.entrar && _erroLogin != null) {
                          return _erroLogin;
                        }
                        return null;
                      },
                    ),
                  ],
                  if (_modo == LoginMode.cadastro ||
                      _modo == LoginMode.recuperar) ...[
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _respostaSegurancaController,
                      decoration: const InputDecoration(
                        label: Text(
                          _perguntaSeguranca,
                          maxLines: 2,
                          style: TextStyle(fontSize: 12, height: 1.45),
                        ),
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.security_outlined),
                      ),
                      onChanged: (_) => _limparErroLogin(),
                      validator: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Informe a resposta';
                        }
                        if (_modo == LoginMode.recuperar &&
                            _erroRecuperacao != null) {
                          return _erroRecuperacao;
                        }
                        return null;
                      },
                    ),
                  ],
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _salvando ? null : _fazerLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE61E4D),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _salvando
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            _botaoPrincipal,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 12,
                    children: [
                      TextButton(
                        onPressed: () => setState(
                          () {
                            _erroLogin = null;
                            _erroRecuperacao = null;
                            _modo = _modo == LoginMode.cadastro
                                ? LoginMode.entrar
                                : LoginMode.cadastro;
                          },
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: linkColor,
                        ),
                        child: Text(
                          _modo == LoginMode.cadastro
                              ? 'Já tenho conta'
                              : 'Criar cadastro',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      TextButton(
                        onPressed: () => setState(() {
                          _erroLogin = null;
                          _erroRecuperacao = null;
                          _modo = LoginMode.recuperar;
                        }),
                        style: TextButton.styleFrom(
                          foregroundColor: linkColor,
                        ),
                        child: const Text(
                          'Recuperar conta',
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
