import 'package:flutter/material.dart';

class NoticiasScreen extends StatefulWidget {
  final bool canEdit;

  const NoticiasScreen({super.key, this.canEdit = false});

  @override
  State<NoticiasScreen> createState() => _NoticiasScreenState();
}

class _NoticiasScreenState extends State<NoticiasScreen> {
  final List<Map<String, String>> _noticias = [
    {
      'titulo': 'Copa do Mundo 2026 tera 48 selecoes',
      'resumo':
          'A competicao passa a ser organizada em 12 grupos, com classificacao ampliada para o mata-mata.',
      'data': '2026',
    },
    {
      'titulo': 'Dezesseis-avos abrem as eliminatorias',
      'resumo':
          'Depois da fase de grupos, 32 equipes disputam jogos unicos no caminho ate a final.',
      'data': 'Formato',
    },
    {
      'titulo': 'Brasil esta no Grupo C',
      'resumo':
          'A selecao brasileira aparece ao lado de Marrocos, Haiti e Escocia no escopo inicial do app.',
      'data': 'Grupos',
    },
  ];

  Future<void> _abrirFormulario() async {
    final tituloController = TextEditingController();
    final resumoController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nova noticia'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: tituloController,
              decoration: const InputDecoration(labelText: 'Titulo'),
            ),
            TextField(
              controller: resumoController,
              decoration: const InputDecoration(labelText: 'Resumo'),
              minLines: 2,
              maxLines: 4,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final titulo = tituloController.text.trim();
              final resumo = resumoController.text.trim();
              if (titulo.isEmpty || resumo.isEmpty) return;
              setState(() {
                _noticias.insert(0, {
                  'titulo': titulo,
                  'resumo': resumo,
                  'data': 'ADM',
                });
              });
              Navigator.pop(context);
            },
            child: const Text('Publicar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Noticias')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _noticias.length,
        itemBuilder: (context, index) {
          final noticia = _noticias[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              leading: const Icon(Icons.article, color: Color(0xFF0B5FFF)),
              title: Text(noticia['titulo']!),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(noticia['resumo']!),
              ),
              trailing: Text(noticia['data']!),
            ),
          );
        },
      ),
      floatingActionButton: widget.canEdit
          ? FloatingActionButton(
              onPressed: _abrirFormulario,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
