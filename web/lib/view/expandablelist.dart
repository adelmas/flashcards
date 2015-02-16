part of view;

class ExpandableList {
  int _height;
  Element _root, _div;
  
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
    }
    else {      
      _div.style.height = "0px";
      _div.style.removeProperty("overflow");
    }
  }
  
  Element get element => _div;
}