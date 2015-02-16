Flashcard app
--------------

A Dart implementation of a spaced repartition flashcard app.

### Algorithm
Based on the Leitner algorithm (http://en.wikipedia.org/wiki/Leitner_system).

The Strategy pattern makes it easy to change the spaced repartition strategy, feel free to implement other algorithms.

### Loading decks
Decks have to be put inside a `<div id="flashcards_deck"></div>` element so that the app can load them, in a Json format as follows :
```
{
  "name":"deck's name",
  "cards":[{"front":"...", "back":"..."},
            {"front":"...", "back":"..."},
            ...]
}
```

### Storage
Uses local storage to save or load a progression.
Other storage methods can be easily implemented.

### View
Displayed inside a `<div id="flashcards_view"></div>` element (by default).

HTML5 / CSS3, fully responsive.

Icons taken from https://www.iconfinder.com/iconsets/flat-ui-icons-24-px (Create Commons license).