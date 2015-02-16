library Card;

class Card {
  String _front = "";
  String _back = "";
  int _rating = 0;
  
  Card(this._front, this._back, this._rating);
  
  int get rating => _rating;
  String get front => _front;
  String get back => _back;
  
  String toString() => "${_front}";
  
  Map<String, String> toJsonMap() {
    Map<String, String> jsonMap = new Map<String, String>();
    
    jsonMap["front"] = _front;
    jsonMap["back"] = _back;
    
    return jsonMap;
  }
  
}