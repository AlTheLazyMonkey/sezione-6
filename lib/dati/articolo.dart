class Articolo {
  int? id;
  late String nome;
  late String quantita;
  String? note;

  Articolo(this.nome, this.quantita, this.note);

  Articolo.daMap(Map<String, dynamic> map) { // Questo è altro metodo costruttore, che prende in ingresso un metodo map e lo converte in oggetto della classe
    id = map['id'];
    nome = map['nome'];
    quantita = map['quantita'];
    note = map['note'];
  }

  Map<String, dynamic> trasformaInMap() {
    // Metodo che restituisce un Map che ha stringhe come chiavi e tipi dinamici come valori
    return {'id': id, 'nome': nome, 'quantita': quantita, 'note': note};
  }
}
