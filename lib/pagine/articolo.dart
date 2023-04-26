import 'package:flutter/material.dart';
import '../dati/articolo.dart';
import '../dati/articolo_db.dart';
import './lista_articoli.dart';

class PaginaArticolo extends StatefulWidget {
  final Articolo articolo;
  final bool nuovo;

  const PaginaArticolo(this.articolo, this.nuovo, {super.key});

  @override
  State<PaginaArticolo> createState() => _PaginaArticoloState();
}

class _PaginaArticoloState extends State<PaginaArticolo> {
  final TextEditingController txtNome = TextEditingController();
  final TextEditingController txtNote = TextEditingController();
  final TextEditingController txtQuantita = TextEditingController();

  @override
  void initState() {
    if (!widget.nuovo) {
      txtNome.text = widget.articolo.nome;
      txtNote.text = widget.articolo.note ?? '';
      txtQuantita.text = widget.articolo.quantita;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dettaglio articolo')),
      floatingActionButton: FloatingActionButton(
        onPressed: salvaArticolo,
        child: const Icon(Icons.save),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          CasellaTesto(txtNome, 'Nome'),
          CasellaTesto(txtNote, 'Note'),
          CasellaTesto(txtQuantita, 'Quantità')
        ]),
      ),
    );
  }

  Future salvaArticolo() async {
    ArticoloDb db = ArticoloDb();
    widget.articolo.nome = txtNome.text;
    widget.articolo.note = txtNote.text;
    widget.articolo.quantita = txtQuantita.text;

    if (widget.nuovo) {
      await db.inserisciArticolo(widget.articolo);
    } else {
      await db.aggiornaArticolo(widget.articolo);
    }

    // ignore: use_build_context_synchronously
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const ListaArticoli()));
  }
}

class CasellaTesto extends StatelessWidget {
  final TextEditingController controller;
  final String titolo;
  const CasellaTesto(this.controller, this.titolo, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(hintText: titolo),
      ),
    );
  }
}
