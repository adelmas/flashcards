library manager;
import 'dart:convert';
import 'dart:collection';
import 'package:observe/observe.dart';
import '../strategy/strategy.dart';
import '../deck/deck.dart';
import '../card/card.dart';
import '../storage/storagemethod.dart';

class Manager extends ChangeNotifier {
  Strategy _strategy;
  Deck _deck;
  @reflectable Card _currentCard = null;
  StorageMethod _storage = null;
  @reflectable String _name = "";
  
  Manager(this._deck, this._strategy, this._storage);
  
  /**
   * Inits components
   */
  void init() {
    HashMap<int, List<Card>> m = new HashMap<int, List<Card>>();
    m[0] = new List<Card>.from(_deck.cards);
    print(m.toString());
    _strategy.map = m;
    _strategy.init();
    _name = notifyPropertyChange(#name, _name, _deck.name);
    deliverChanges();
    nextCard();
  }
  
  /**
   * Strategy
   */
  set strategy(Strategy strategy) => _strategy = strategy;
  Strategy get strategy => _strategy;
  
  @reflectable Card nextCard() {
    Card c = strategy.nextCard;
    if (c == _currentCard)
      _currentCard = new Card("", "", 0); /* Making sure the observer is notified even if _currentCard = c */
    _currentCard = notifyPropertyChange(#currentCard, _currentCard, c);
    return c;
  }
  
  void knewIt(Card c, bool b) {
    _strategy.knewIt(c, b);
  }
  
  int get nbCompletedCards => _strategy.nbCompletedCards;
  
  Card get currentCard => _currentCard;
  
  /**
   * Save / Load
   */
  String toJson() {
    return JSON.encode(_strategy.toJsonMap());
  }
  
  StorageMethod get storage => _storage;
  List<String> get saveNamesList => _storage.saveNamesList;
  void loadJson(String key) {
    Map jsonMap = _storage.loadJson(key);
    if (jsonMap == null) {
      print("manager.loadJson(" + key + ") : Error (jsonMap = null)");
      return;
    }
    _strategy.fromJsonMap(jsonMap);
    
    _name = "";
    try {
      _name = notifyPropertyChange(#name, _name, key.split("_")[1]);
      deliverChanges();
    } catch (RangeError) {
      print("Error in name format");
    }
  }
  
  void store() {
    if (!_strategy.isOver)
      _storage.storeJson(_name, toJson());
  }
  
  /**
   * Deck
   */
  Deck get deck => _deck;
  set deck(Deck deck) => _deck = deck;
  int get nbCards => _strategy.nbCards;
  String get name => _name;
  
}