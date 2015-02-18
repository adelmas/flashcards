library leitner;
import 'dart:collection';
import '../card/card.dart';
import 'strategy.dart';

class LeitnerStrategy extends Strategy {
  int _currentBox = 0, _maxBox = 2;
  int _nbCards = 0;
  /* Correct answers waiting to be moved up at the end of the round */
  Map<int, List<Card>> _greenMap = new Map<int, List<Card>>();
  /* Uncorrect answers that have to be put back in the first box */
  Map<int, List<Card>> _redMap = new Map<int, List<Card>>();
  /* Current list of cards submitted to the user */
  List<Card> _currentList = new List<Card>();
  
  /**
   * Constructors
   */
  LeitnerStrategy.fromHashMap(HashMap<int, Card> hmap) {
    map = hmap;
    _nbCards = map.length;
    initMaps();
  }
  
  LeitnerStrategy.fromList(List<Card> cards) {
    map[0] = cards;
    _nbCards = map[0].length;
    initMaps();
  }
  
  LeitnerStrategy() {
    initMaps();
  }
  
  /**
   * Resets all the boxes.
   * Moves all the cards down to box 0 and clears the maps.
   */
  void reset() {
    for (int i=1; i<=_maxBox; i++) {
      for (Card c in map[i]) {
        map[i].remove(c);
        map[0].add(c);
      }
      _greenMap[i-1].clear();
      _redMap[i-1].clear();
    }
    _greenMap[0].clear();
    _redMap[0].clear();
  }

  /**
   * Returns the next card according to the Leitner algorithm.
   */
  @override
  get nextCard {
    if (isOver)
      return null;
    while (_currentList.length == 0) {
      _currentBox++;
      if (_currentBox == _maxBox) {
        processBoxes();
        if (isOver)
          return null;
        _currentBox = 0;
      }
      _currentList = map[_currentBox].toList();
    }    

    return _currentList.removeLast();
  }

  /**
   * Processes Leitner algorithm.
   * Correct answers are moved up to the next box.
   * Wrong answers are moved down to the first box.
   */
  void processBoxes() {
    /* Move cards */
    for (int lvl in _greenMap.keys) {
      for (Card c in _greenMap[lvl]) {
        map[lvl].remove(c);
        map[lvl+1].add(c);
      }
      for (Card c in _redMap[lvl]) {
        map[lvl].remove(c);
        map[0].add(c);
      }
      _greenMap[lvl].clear();
      _redMap[lvl].clear();
    }
    
    shuffleBoxes();
    print(map.toString());
  }
  
  /**
   * Shuffles card lists in the map.
   */
  void shuffleBoxes() {
    for (int lvl in map.keys)
      map[lvl].shuffle();
  }
  
  @override
  bool get isOver {
    return map[_maxBox].length == _nbCards;
  }

  /**
   * Adds a known card to the green map for Leitner algorithm.
   */
  @override
  void knewIt(Card c, bool b) {
    if (isOver)
      return;
    if (b)
      _greenMap[_currentBox].add(c);
    else
      _redMap[_currentBox].add(c);
  }
  
  @override
  void dontAsk(Card c) {
    if (c != null) {
      if (map[_currentBox].contains(c))
        map[_currentBox].remove(c);
      map[_maxBox].add(c);
    }
  }
  
  String toString() {
    String str = "";
    
    for (int lvl in map.keys) {
      str += "Level $lvl :\n";
      map[lvl].forEach((e) => str += e.toString() + "\n");
      str += "----\n";
    }
    return str;
  }

  @override
  set map(Map map) {
    super.map = map;
    _nbCards = map[0].length;
    initMaps();
  }

  /**
   * Sets up the maps
   */
  void initMaps() {
    for (int i=1; i<=_maxBox; i++) {
      map[i] = new List<Card>();
      _greenMap[i-1] = new List<Card>();
      _redMap[i-1] = new List<Card>();
    }
    if (map[0] == null)
      map[0] = new List<Card>();
    _currentList = map[_currentBox].toList();
  }
  
  @override
  void init() {
    _currentBox = 0;
    reset();
  }

  @override
  Map toJsonMap() {
    Map cardMap = new Map(), jsonMap = new Map();
    int nbCards = 0;
    
    for (int lvl in map.keys) {
      cardMap['$lvl'] = new List<Card>.from(map[lvl]);
    }
    
    for (int lvl in _greenMap.keys) {
      for (Card c in _greenMap[lvl]) {
        cardMap['$lvl'].remove(c);
        cardMap['${lvl+1}'].add(c);
      }
      for (Card c in _redMap[lvl]) {
        cardMap['$lvl'].remove(c);
        cardMap['0'].add(c);
      }
    }
    
    for (String k in cardMap.keys) {
      jsonMap[k] = new List<Map>();
      for (Card c in cardMap[k]) {
        jsonMap[k].add(new Map.from(c.toJsonMap()));
        nbCards++;
      }
    }
    
    _nbCards = nbCards;
    
    return jsonMap;
  }

  @override
  int get nbCompletedCards => (isOver) ? _nbCards : _greenMap[_maxBox-1].length + map[_maxBox].length;

  /**
   * Resets the boxes and loads a progression.
   */
  @override
  void fromJsonMap(Map m) {
    int nbBoxes = 0;
    
    _currentList.clear();
    initMaps();
    map[0].clear();
    _currentBox = 0;

    for (String k in m.keys) {
      int lvl = int.parse(k);
      Card c;
      m[k].forEach((el) {
        c = new Card(el['front'], el['back'], 0);
        if (map[lvl] == null)
          map[lvl] = new List<Card>();
        map[lvl].add(c);
      });
      nbBoxes++;
    }
    
    _maxBox = nbBoxes-1;
    _currentList = map[0].toList();
    print(map.toString());
  }

  @override
  int get nbCards => _nbCards;
}