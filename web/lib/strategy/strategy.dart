import '../card/card.dart';

/**
 * Based on the Strategy pattern
 */
abstract class Strategy {
  Map _map = new Map();
  
  void knewIt(Card, bool);
  void dontAsk(Card);
  void init();
  void reset();
  
  Card get nextCard;
  bool get isOver;
  Map get map => _map;
  set map(Map map) => _map = map;
  int get nbCompletedCards;
  int get nbCards;
  
  Map toJsonMap();
  void fromJsonMap(Map);
}
