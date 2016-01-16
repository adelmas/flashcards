
import 'lib/deck/deck.dart';
import 'lib/strategy/leitnerstrategy.dart';
import 'lib/manager/manager.dart';
import 'lib/view/view.dart';
import 'lib/storage/localstorage.dart';
import 'dart:html';
import 'dart:convert';

void main() {
  Deck deck = null;
  try {
    deck = new Deck.fromJsonMap(JSON.decode(querySelector("#flashcards_deck").text));
  } catch (FormatException) {
    print("Error : Bad format in Json deck");
  }
  
  Manager manager = new Manager(deck, new LeitnerStrategy(), new LocalStorage());
  manager.deck = deck;
  View v = new View(querySelector("#flashcards_view"), manager, 1024);
  manager.init();

  return;
}