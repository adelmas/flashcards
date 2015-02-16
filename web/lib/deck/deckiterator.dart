part of deck;

class DeckIterator implements Iterator {
  Deck _deck;
  int _index;
  
  DeckIterator(this._deck) {
    _index = -1;
  }
  
  bool hasNext() => _index < _deck.length;
  
  void rewind() {
    _index = -1;
  }
  
  @override
  get current => _deck[_index];

  @override
  bool moveNext() {
    _index++;
    if (_index >= _deck.length) {
      //print("$this : No item left.");
      return false;
    }
    return true;
  }
}