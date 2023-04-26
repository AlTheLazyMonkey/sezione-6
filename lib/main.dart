import 'package:flutter/material.dart';
import 'package:flutter_application_6/dati/articolo.dart';
import 'package:flutter_application_6/pagine/lista_articoli.dart';
import './dati/articolo_db.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const ListaArticoli());
  }
}

class ProvaDb extends StatefulWidget {
  const ProvaDb({super.key});

  @override
  State<ProvaDb> createState() => _ProvaDbState();
}

class _ProvaDbState extends State<ProvaDb> {
  int id = 0;

  @override
  void initState() {
    provaDb();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SpesApp')),
      body: Center(
          child: Container(
        child: Text(id.toString()),
      )),
    );
  }

  Future provaDb() async {
    ArticoloDb articoloDb = ArticoloDb();
    Articolo articolo = Articolo('Mela', '2kg', 'Da spremuta');
    id = await articoloDb.inserisciArticolo(articolo);
    setState(() {
      id = id;
    });
  }
}
