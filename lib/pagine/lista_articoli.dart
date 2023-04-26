import 'package:flutter/material.dart';
import 'package:flutter_application_6/pagine/articolo.dart';
import '../dati/articolo.dart';
import '../dati/articolo_db.dart';

class ListaArticoli extends StatefulWidget {
  const ListaArticoli({super.key});

  @override
  State<ListaArticoli> createState() => _ListaArticoliState();
}

class _ListaArticoliState extends State<ListaArticoli> {
  late ArticoloDb db;

  @override
  void initState() {
    db = ArticoloDb();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista della spesa'),
        actions: [
          IconButton(
              onPressed: cancellaTutto, icon: const Icon(Icons.delete_sweep))
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) =>
                        PaginaArticolo(Articolo('', '', ''), true))));
          },
          child: const Icon(Icons.add)),
      body: FutureBuilder(
        future: leggiArticoli(),
        builder: (context, snapshot) {
          List<Articolo> lista = snapshot.data ?? [];
          return ListView.builder(
              itemCount: lista.length,
              itemBuilder: (_, index) {
                return Dismissible(
                  key: Key(lista[index].id.toString()),
                  onDismissed: (_) {
                    db.eliminaArticolo(lista[index]);
                  },
                  child: ListTile(
                      title: Text(lista[index].nome),
                      subtitle: Text(
                          'Quantità ${lista[index].quantita} - Note ${lista[index].note ?? ''}'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PaginaArticolo(lista[index], false)));
                      }),
                );
              });
        },
      ),
    );
  }

  Future leggiArticoli() async {
    List<Articolo> articoli = await db.leggiArticoli();
    return articoli;
  }

  void cancellaTutto() {
    AlertDialog alert = AlertDialog(
      title: const Text('Sei sicuro di voler eliminare tutti gli elementi?'),
      content: const Text('Questa operazione è irreversibile.'),
      actions: [
        TextButton(
            onPressed: () {
              db.eliminaDatiDb().then((value) {
                setState(() {
                  db = ArticoloDb();
                });
                Navigator.pop(context);
              });
            },
            child: const Text('SI')),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('NO'))
      ],
    );

    showDialog(
        context: context,
        builder: (context) {
          return alert;
        });
  }
}
