import 'dart:core';


class MyTranslations{
  Map<String, Map<String, String>> _allTexts;
  MyTranslations(){
    _allTexts = new Map();
    Map<String, String> en = new Map();
    Map<String, String> de = new Map();
    Map<String, String> fr = new Map();
    Map<String, String> es = new Map();
    Map<String, String> ua = new Map();
    Map<String, String> ru = new Map();
    ///en
    en.putIfAbsent('title', () => 'Least Squares Calculator');
    en.putIfAbsent('calculateButtonName', () => 'Add &\nCalculate');
    en.putIfAbsent('nanMessage', () => 'Is not a Number');
    en.putIfAbsent('nanData', () => 'No data');
    en.putIfAbsent('settings', () => 'Settings');
    en.putIfAbsent('reset', () => 'Reset\ndata');
    ///es
    es.putIfAbsent('title', () => 'Mínimos cuadrados');
    es.putIfAbsent('calculateButtonName', () => 'Add &\nCalculate');
    es.putIfAbsent('nanMessage', () => 'Is not a Number');
    es.putIfAbsent('nanData', () => 'No data');
    es.putIfAbsent('settings', () => 'Settings');
    es.putIfAbsent('reset', () => 'Reset\ndata');
    ///fr
    fr.putIfAbsent('title', () => 'Méthode des moindres carrés');
    fr.putIfAbsent('calculateButtonName', () => 'Add &\nCalculate');
    fr.putIfAbsent('nanMessage', () => 'Is not a Number');
    fr.putIfAbsent('nanData', () => 'No data');
    fr.putIfAbsent('settings', () => 'Settings');
    fr.putIfAbsent('reset', () => 'Reset\ndata');
    ///de
    de.putIfAbsent('title', () => 'Kleinsten Quadrate');
    de.putIfAbsent('calculateButtonName', () => 'Add &\nCalculate');
    de.putIfAbsent('nanMessage', () => 'Is not a Number');
    de.putIfAbsent('nanData', () => 'No data');
    de.putIfAbsent('settings', () => 'Settings');
    de.putIfAbsent('reset', () => 'Reset\ndata');
    ///ua
    ua.putIfAbsent('title', () => 'Обчислення найменших квадратів');
    ua.putIfAbsent('calculateButtonName', () => 'Додати\nзначення');
    ua.putIfAbsent('nanMessage', () => 'Результат не є числом');
    ua.putIfAbsent('nanData', () => 'Відсутні дані');
    ua.putIfAbsent('settings', () => 'Налаштування');
    ua.putIfAbsent('reset', () => 'Очистити\nдані');
    ///ru
    ru.putIfAbsent('title', () => 'Вычисление наименьших квадратов');
    ru.putIfAbsent('calculateButtonName', () => 'Добавить\nзначения');
    ru.putIfAbsent('nanMessage', () => 'Is not a Number');
    ru.putIfAbsent('nanData', () => 'Нет данных');
    ru.putIfAbsent('settings', () => 'Настройки');
    ru.putIfAbsent('reset', () => 'Очистить\nданные');

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
