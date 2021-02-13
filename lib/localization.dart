import 'dart:core';


class MyLocalization{
  Map<String, Map<String, String>> _allTexts;
  MyLocalization(){
    _allTexts = new Map();
    Map<String, String> en = new Map();
    Map<String, String> ua = new Map();
    Map<String, String> ru = new Map();
    ///en
    en.putIfAbsent('title', () => 'Least Squares Calculator');
    en.putIfAbsent('calculateButtonName', () => 'Add &\nCalculate');
    en.putIfAbsent('nanMessage', () => 'Is not a Number');
    ///ua
    ua.putIfAbsent('title', () => 'Обчислення найменших квадратів');
    ua.putIfAbsent('calculateButtonName', () => 'Додати\nзначення');
    ua.putIfAbsent('nanMessage', () => 'Результат не є числом');
    ///ru
    ru.putIfAbsent('title', () => 'Вычисление наименьших квадратов');
    ru.putIfAbsent('calculateButtonName', () => 'Добавить\nзначения');
    ru.putIfAbsent('nanMessage', () => 'Is not a Number');

    _allTexts.putIfAbsent('en', () => en);
    _allTexts.putIfAbsent('ua', () => ua);
    _allTexts.putIfAbsent('ru', () => ru);
  }

  String getLocale(String loc, String phrase){
    String _resultString = 'no string';
    if(_allTexts[loc] == null)
      loc = 'en';
    _allTexts[loc].forEach((key, value) {
      int _result = key.compareTo(phrase);
      if(_result == 0)
        _resultString = value;
    });
    return _resultString;
  }

}
