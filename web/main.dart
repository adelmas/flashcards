// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'lib/deck/deck.dart';
import 'lib/strategy/leitnerstrategy.dart';
import 'lib/manager/manager.dart';
import 'lib/view/view.dart';
import 'lib/storage/localstorage.dart';
import 'dart:html';
import 'dart:convert';

void main() {
  Deck deck = new Deck.fromJsonMap(JSON.decode(querySelector("#flashcards_deck").text));

  Manager manager = new Manager(deck, new LeitnerStrategy(), new LocalStorage());
  manager.deck = deck;
  View v = new View(querySelector("#flashcards_view"), manager, 600);
  manager.init();

  return;
}
