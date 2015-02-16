part of view;

class Button {
  Element _el;

  Button(Element root, String text, String strClass, String strId, void clickFn(MouseEvent T), [String ico = ""]) {
    _el = new ButtonElement();

    if (ico != "") {
      _el.style.backgroundImage = "url(" + ico + ")";
      _el.style.backgroundRepeat = "no-repeat";
      _el.style.backgroundPosition = "5px center";
      /* backgroundPositionX/Y doesn't work on Firefox */
      _el.style.paddingLeft = "25px";
    }

    _el.appendText(text);
    _el.classes.add(strClass);
    _el.id = strId;
    _el.onClick.listen(clickFn);
    
    root.children.add(_el);
  }

  Element get element => _el;
}
