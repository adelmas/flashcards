library deck;
import '../card/card.dart';
part 'deckiterator.dart';

class Deck implements Iterable {
  List<Card> _cards = new List<Card>();
  String _name = "";
  
  /**
   * Constructors
   */
  Deck(this._name);
  
  Deck.fromList(this._name, this._cards);
  
  Deck.fromJsonMap(Map jsonData) {
    if (!jsonData.containsKey("cards"))
      return;
    
    _name = jsonData["name"];
    List<Map> l = new List<Map>.from(jsonData["cards"]);
    if (l.isEmpty)
      return;
    
    l.forEach((el) => addCard(new Card(el["front"], el["back"], 0)));
  }
  
  /**
   * Returns a Json map of the deck
   */
  Map toJsonMap() {
    Map jsonMap = new Map();
    int i = 1;
    
    var it = iterator;
    jsonMap["name"] = _name;
    jsonMap["cards"] = new List<Map>();
    while (it.moveNext()) {
      Card c = it.current;
      jsonMap["cards"].add(new Map.from(c.toJsonMap()));
      i++;
    }
    
    return jsonMap;
  }
  
  /**
   * Adds a card to the deck
   */
  addCard(Card c) {
    _cards.add(c);
  }
  
  void clear() {
    _cards.clear();
  }
  
  /**
   * 
   */
  String toString() {
    String str = "";
    str += _cards.toString();
    return str;
  }
  
  /**
   * Accessors
   */
  get cards => _cards;
  String get name => _name;
  
  @override
  get iterator => new DeckIterator(this);
  
  @override
  int get length => _cards.length;
  
  Card operator [](int i) => _cards.elementAt(i);

  @override
  bool any(bool test(element)) {
    // TODO: implement any
  }

  @override
  bool contains(Object element) {
    // TODO: implement contains
  }

  @override
  elementAt(int index) {
    // TODO: implement elementAt
  }

  @override
  bool every(bool test(element)) {
    // TODO: implement every
  }

  @override
  Iterable expand(Iterable f(element)) {
    // TODO: implement expand
  }

  // TODO: implement first
  @override
  get first => null;

  @override
  firstWhere(bool test(element), {orElse()}) {
    // TODO: implement firstWhere
  }

  @override
  fold(initialValue, combine(previousValue, element)) {
    // TODO: implement fold
  }

  @override
  void forEach(void f(element)) {
    // TODO: implement forEach
  }

  // TODO: implement isEmpty
  @override
  bool get isEmpty => null;

  // TODO: implement isNotEmpty
  @override
  bool get isNotEmpty => null;

  @override
  String join([String separator = ""]) {
    // TODO: implement join
  }

  // TODO: implement last
  @override
  get last => null;

  @override
  lastWhere(bool test(element), {orElse()}) {
    // TODO: implement lastWhere
  }

  @override
  Iterable map(f(element)) {
    // TODO: implement map
  }

  @override
  reduce(combine(value, element)) {
    // TODO: implement reduce
  }

  // TODO: implement single
  @override
  get single => null;

  @override
  singleWhere(bool test(element)) {
    // TODO: implement singleWhere
  }

  @override
  Iterable skip(int n) {
    // TODO: implement skip
  }

  @override
  Iterable skipWhile(bool test(value)) {
    // TODO: implement skipWhile
  }

  @override
  Iterable take(int n) {
    // TODO: implement take
  }

  @override
  Iterable takeWhile(bool test(value)) {
    // TODO: implement takeWhile
  }

  @override
  List toList({bool growable: true}) {
    // TODO: implement toList
  }

  @override
  Set toSet() {
    // TODO: implement toSet
  }

  @override
  Iterable where(bool test(element)) {
    // TODO: implement where
  }
}