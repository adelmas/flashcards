library storage;

abstract class StorageMethod {
  
  void storeJson(String key, String str);
  Map loadJson(String key);
  String toString();
  
  List<String> get saveNamesList;
  
}