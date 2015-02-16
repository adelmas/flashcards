part of view;

/* Since the <progress> element isn't working on some mobile devices... */
class Progress {
  Element _container, _bar;
  double _value = 0.0;
  
  Progress(Element root, String strBarClass, String strId) {
    _container = new DivElement();
    _bar = new SpanElement();
    
    _container.id = strId;
    _container.style.width = "100%";
    _bar.classes.add(strBarClass);
    _bar.style.width = "0%";
    
    _container.children.add(_bar);
    root.children.add(_container);
  }
  
  set value(double value) {
    _value = value;
    _bar.style.width = value.toInt().toString()+"%";
  }
  
  double get value => _value;
  
}