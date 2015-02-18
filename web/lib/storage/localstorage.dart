import 'dart:html';
import 'storagemethod.dart';
import 'dart:convert';

class LocalStorage implements StorageMethod {
  Storage _localStorage = null;
  
  LocalStorage() {
    _localStorage = window.localStorage;
  }

  @override
  void storeJson(String key, String str) {
    _localStorage["flashcards_${key}"] = str;
  }
  
  String toString() {
    return "";
  }

  @override
  List<String> getSaveNamesList([String filter = ""]) {
    List<String> list = new List<String>();
    for (String str in _localStorage.keys) {
      if (str.startsWith(filter))
        list.add(str);
    }
    return list;
  }

  @override
  Map loadJson(String key) {
    return JSON.decode(_localStorage[key]);
  }
}