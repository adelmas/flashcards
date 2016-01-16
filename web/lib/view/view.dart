library view;

import 'dart:html';
import '../card/card.dart';
import '../manager/manager.dart';
import 'package:observe/observe.dart';
@MirrorsUsed(symbols: 'manager', override: '*') /* Saves ~200Ko... */
import 'dart:mirrors';

part 'button.dart';
part 'progress.dart';
part 'expandablelist.dart';

class View {
  Element _dRoot, _dPanel, _dCard, _dName, _dInfos, _dCards, _dLinks, _dProgress, _dLoad;
  ButtonElement _bKnewIt, _bTurnOver, _bForgot, _bDontAskAgain;
  Element _aInfos, _aCards, _aSave, _aLoad, _aRestart;
  Progress _progress;
  ExpandableList _lDeck, _lLoad, _lLinks;
  Manager _manager;
  List<Element> _lButtons = new List<Element>();
  int _currentView = 0, _width = 0, _nbCards = 0;
  String _anchorRoot = "", _iconPrefix = "";//flashcards/";
  NodeValidator _validator = new NodeValidatorBuilder()
  ..allowHtml5()
  ..allowTextElements()
  ..allowElement('a', attributes: ['href']);
  
  View(this._dRoot, this._manager, this._width, [bool responsive=true]) {
    if (_dRoot == null) {
      print("Root div not found in the html page.");
      return;
    }
    if (_manager == null) {
      print("manager = null");
      return;
    }
    
    //_idRoot = _dRoot.getAttribute("id");
    _anchorRoot = "";

    /* Title */
    _dName = new DivElement();
    _aRestart = new AnchorElement()
    ..href="#${_anchorRoot}"
    ..setAttribute("title", "Restart")
    ..style.display = "inline-block"
    ..style.height = "16px"
    ..style.paddingLeft = "20px"
    ..style.backgroundRepeat = "no-repeat"
    ..style.backgroundImage = "url(${_iconPrefix}icons/restart.png)"
    ..onClick.listen((e) {
      _manager.reset();
    });
    _dName.children.add(_aRestart);
    _dName.classes.add("title");
    _dName.appendText(_manager.name + " (" +_manager.nbCards.toString() + " cards)");
    
    /* Divs */
    _dPanel = new DivElement();
    _dPanel.classes.add("panel");
    _dRoot.children.add(_dPanel);
    _dPanel.children.add(_dName);
    _dCard = new DivElement();
    _dCard.classes.add("card");
    _dPanel.children.add(_dCard);
    
    /* Buttons */
    Button b;
    b = new Button(_dPanel, "Turn over", "button", "bTurnOver", (evt) {
      if (_manager.currentCard == null)
              return;
      Card c = _manager.currentCard;
      _dCard.setInnerHtml("${c.front}<br /><span class=\"back\">${c.back}</span>", validator: _validator);     
      _bKnewIt.attributes.remove("disabled");
      _bForgot.attributes.remove("disabled");
    }, "${_iconPrefix}icons/eye.png");
    _bTurnOver = b.element;
    
    b = new Button(_dPanel, "Don't ask again", "button", "bDontAskAgain", (evt) {
      _manager.dontAsk(_manager.currentCard);
      _manager.nextCard();
      }, "${_iconPrefix}icons/ok.png");
    _bDontAskAgain = b.element;
    
    b = new Button(_dPanel, "I knew it", "button", "bKnewIt", (evt) {
      _manager.knewIt(_manager.currentCard, true);
      _manager.nextCard();
    }, "${_iconPrefix}icons/check.png");
    _bKnewIt = b.element;
    
    b = new Button(_dPanel, "I forgot", "button", "bForgot", (evt) {
      _manager.knewIt(_manager.currentCard, false);
      _manager.nextCard();
    }, "${_iconPrefix}icons/cross.png");
    _bForgot = b.element;
    
    _lButtons.add(_bTurnOver);
    _lButtons.add(_bKnewIt);
    _lButtons.add(_bForgot);
    _lButtons.add(_bDontAskAgain);
    
    /* Footer */
    _progress = new Progress(_dPanel, "progressBar", "dProgress");
    
    _dLinks = new DivElement();
    _dLinks.classes.add("dLinks");
    _dPanel.children.add(_dLinks);
    _aLoad = new AnchorElement()
    ..href = "#${_anchorRoot}";
    _aLoad.classes.add("infos");
    _aLoad.text = "Load a progression";
    _dLinks.children.add(_aLoad);
    _aLoad.onClick.listen((el) {
      if (!_lLoad.isExpanded)
        appendSaveNamesList(_lLoad);
      _lLoad.trigger();
      });
    _aSave = new AnchorElement()
    ..href = "#${_anchorRoot}";
    _aSave.classes.add("infos");
    _aSave.text = "Save";
    _dLinks.children.add(_aSave);
    _aSave.onClick.listen((evt) { 
      _manager.store();
      appendSaveNamesList(_lLoad);
    });
    _aCards = new AnchorElement()
    ..href = "#${_anchorRoot}";
    _aCards.classes.add("infos");
    _aCards.text = "Show the deck";
    _dLinks.children.add(_aCards);
    _aCards.onClick.listen((evt) => _lDeck.trigger());
    _aInfos = new AnchorElement()
    ..href = "#${_anchorRoot}";
    _aInfos.classes.add("infos");
    _aInfos.text = "Infos";
    _dLinks.children.add(_aInfos);
    _aInfos.onClick.listen(showInfos);
    
    _lLoad = new ExpandableList(_dPanel, 70, "dInfos");
    _dLoad = _lLoad.element;
    appendSaveNamesList(_lLoad);
    
    _lDeck = new ExpandableList(_dPanel, 70, "dInfos");
    _dCards = _lDeck.element;
    appendDeck(_lDeck);
    
    _lLinks = new ExpandableList(_dPanel, 20, "dInfos");
    _dInfos = _lLinks.element;
    _dInfos.setInnerHtml("<a href=\"https://github.com/adelmas/flashcards\">GitHub</a> <a href=\"contact.php\">Signaler une erreur</a>", validator:_validator);
    
    /* Observer */
    _manager.changes.listen((List<ChangeRecord> evt) => update(evt));

    /* Responsive */
    if (responsive) {
      if (window.innerWidth > _width)
        _currentView = 0;
      else {
        _currentView = 1;
        setVerticalView();
      }
      window.onResize.listen(resize);
    }
  }
  
  /**
   * Updates the list of save names
   */
  void appendSaveNamesList(ExpandableList lLoad) {
    if (_manager.saveNamesList != null) {
      lLoad.clear();
      _manager.saveNamesList.forEach((name) {
        Element el = new DivElement();
        el.classes.add("list_thumb");
        el.text = name;
        Element link = new AnchorElement()
        ..classes.add("right")
        ..href = "#${_anchorRoot}"
        ..onClick.listen((evt) {
          _manager.loadJson(name);
          _manager.nextCard();
        })
        ..text = "Load";
        el.append(link);
        _lLoad.append(el);
      });
    }
  }
  
  /**
   * Displays the cards in current deck.
   */
  void appendDeck(ExpandableList lDeck) {
    if (_manager.deck == null)
      return;
    var it = _manager.deck.iterator;
    _lDeck.clear();
    while (it.moveNext()) {
      Card c = it.current;
      Element el = new DivElement();
      el.classes.add("list_thumb");
      el.text = c.front;
      _lDeck.append(el);
      _nbCards++;
    }
  }
  
  /**
   * Displays or hides infos div
   */
  void showInfos(Event e) {
    if (_dInfos.style.height == "0px") {
      _dInfos.style.height = "20px";
      _dInfos.style.marginTop = "5px";
    }
    else {      
      _dInfos.style.height = "0px";
      _dInfos.style.marginTop = "0px";
    }
  }
  
  /**
   * Called whenever the window is being resized.
   * Switches view if needed.
   */
  void resize(Event e) {
    if (window.innerWidth <= _width && _currentView == 0) {
      setVerticalView();
      _currentView = 1;
    }
    else if (window.innerWidth > _width && _currentView == 1) {
      setHorizontalView();
      _currentView = 0;
    }
  }
  
  /**
   * Triggered whenever the manager notifies
   * with notifyPropertyChange() and deliverChanges()
   */
  void update(List<ChangeRecord> evt) {
    PropertyChangeRecord rec = evt[0];
    String sourceName = MirrorSystem.getName(rec.name);
    if (sourceName == "currentCard") {
      _progress.value = _manager.nbCompletedCards*100/_manager.nbCards;
      if (_manager.currentCard == null) {
        _dCard.setInnerHtml("<b>Congratulations !</b><br />", validator: _validator);
        return;
      }
      _dCard.setInnerHtml(_manager.currentCard.front);
      
      _bKnewIt.disabled = true;
      _bForgot.disabled = true;
    }
    else if (sourceName == "name") {
      _dName.childNodes.last.remove();
      _dName.appendText(_manager.name + " (" + _manager.nbCards.toString() + " cards)");
    }
    else if (sourceName == "deck") {
      appendDeck(_lDeck);
    }
  }
  
  /**
   * Sets the vertical view adapted for tiny screens
   */
  void setVerticalView() {
    _lButtons.forEach((el) {
      el.style.width = "100%";
      el.style.display = "block";
      el.style.height = "35px";
    });
  }

  /**
   * Sets the horizontal view (default)
   */
  void setHorizontalView() {
    _lButtons.forEach((el) {
      el.style.removeProperty("width");
      el.style.removeProperty("display");
      el.style.removeProperty("height");
    });
  }
  
}