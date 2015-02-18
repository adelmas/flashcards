part of view;

class ExpandableList implements Iterable {
  int _height;
  Element _root, _div;
  bool _expanded = false;
  
  ExpandableList(this._root, this._height, String strClass) {
    _div = new DivElement()
    ..style.height = "0px"
    ..classes.add(strClass);
    _root.children.add(_div);
  }
  
  void append(Element el) {
    _div.children.add(el);
  }
  
  void trigger() {
    if (_div.style.height == "0px") {
      _div.style.height = _height.toString() + "px";
      _div.style.overflow = "auto";
      _expanded = true;
    }
    else {      
      _div.style.height = "0px";
      _div.style.removeProperty("overflow");
      _expanded = false;
    }
  }
  
  void clear() {
    _div.children.clear();
  }
  
  Element get element => _div;
  bool get isExpanded => _expanded;
  

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

  // TODO: implement iterator
  @override
  Iterator get iterator => null;

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

  // TODO: implement length
  @override
  int get length => null;

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