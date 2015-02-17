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
    _localStorage["flashcards_" + key] = str;
  }
  
  String toString() {
    return "";
  }

  @override
  List<String> get saveNamesList => _localStorage.keys.toList();

  @override
  Map loadJson(String key) {
    return JSON.decode(_localStorage[key]);
  }
}