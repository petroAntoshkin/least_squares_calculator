import 'dart:core';


class MyTranslations{
  Map<String, Map<String, String>> _allTexts;
  MyTranslations(){
    _allTexts = new Map();
    Map<String, String> en = new Map();
    Map<String, String> zh = new Map();
    Map<String, String> hi = new Map();
    Map<String, String> de = new Map();
    Map<String, String> fr = new Map();
    Map<String, String> es = new Map();
    Map<String, String> pt = new Map();
    Map<String, String> ua = new Map();
    Map<String, String> ru = new Map();
    ///en
    en.putIfAbsent('title', () => 'Least Squares Calculator');
    en.putIfAbsent('calculateButtonName', () => 'Add &\nCalculate');
    en.putIfAbsent('nanMessage', () => 'Is not a Number');
    en.putIfAbsent('nanData', () => 'No data');
    en.putIfAbsent('settings', () => 'Settings');
    en.putIfAbsent('reset', () => 'Reset\ndata');
    en.putIfAbsent('show_grid', () => 'Show grid');
    ///zh
    zh.putIfAbsent('title', () => '最小二乘');
    zh.putIfAbsent('calculateButtonName', () => '加和計算');
    zh.putIfAbsent('nanMessage', () => '不是數字');
    zh.putIfAbsent('nanData', () => '沒有數據');
    zh.putIfAbsent('settings', () => '設定值');
    zh.putIfAbsent('reset', () => '重置數據');
    zh.putIfAbsent('show_grid', () => '顯示網格');
    ///hi
    hi.putIfAbsent('title', () => 'कम से कम दो गुना');
    hi.putIfAbsent('calculateButtonName', () => 'जोड़ें और गणना करें');
    hi.putIfAbsent('nanMessage', () => 'एक संख्या नहीं है');
    hi.putIfAbsent('nanData', () => 'कोई आकड़ा उपलब्ध नहीं है');
    hi.putIfAbsent('settings', () => 'समायोजन');
    hi.putIfAbsent('reset', () => 'रीसेट\nडेटा');
    hi.putIfAbsent('show_grid', () => 'ग्रिड दिखाएं');
    ///es
    es.putIfAbsent('title', () => 'Mínimos cuadrados');
    es.putIfAbsent('calculateButtonName', () => 'Agregar & \ nCalculate');
    es.putIfAbsent('nanMessage', () => 'No es un número');
    es.putIfAbsent('nanData', () => 'Sin datos');
    es.putIfAbsent('settings', () => 'Configuración');
    es.putIfAbsent('reset', () => 'Reset\ndata');
    es.putIfAbsent('show_grid', () => 'Mostrar cuadrícula');
    ///fr
    fr.putIfAbsent('title', () => 'Méthode des moindres carrés');
    fr.putIfAbsent('calculateButtonName', () => 'Ajouter & \ nCalculer');
    fr.putIfAbsent('nanMessage', () => 'N\'est pas un nombre');
    fr.putIfAbsent('nanData', () => 'Aucune donnée');
    fr.putIfAbsent('settings', () => 'Paramètres');
    fr.putIfAbsent('reset', () => 'Réinitialiser\ndonnées');
    fr.putIfAbsent('show_grid', () => 'Afficher la grille');
    ///de
    de.putIfAbsent('title', () => 'Kleinsten Quadrate');
    de.putIfAbsent('calculateButtonName', () => 'Hinzufügen &\nBerechnen');
    de.putIfAbsent('nanMessage', () => 'Ist keine Zahl');
    de.putIfAbsent('nanData', () => 'Keine Daten');
    de.putIfAbsent('settings', () => 'die Einstellungen');
    de.putIfAbsent('reset', () => 'Daten\nzurücksetzen');
    de.putIfAbsent('show_grid', () => 'Rasteranzeige');
    ///pt
    pt.putIfAbsent('title', () => 'Mínimos quadrados');
    pt.putIfAbsent('calculateButtonName', () => 'Adicionar e\ncalcular');
    pt.putIfAbsent('nanMessage', () => 'Não é um número');
    pt.putIfAbsent('nanData', () => 'Sem dados');
    pt.putIfAbsent('settings', () => 'Configurações');
    pt.putIfAbsent('reset', () => 'Redefinir\ndados');
    pt.putIfAbsent('show_grid', () => 'Mostre as grades');
    ///ua
    ua.putIfAbsent('title', () => 'Обчислення найменших квадратів');
    ua.putIfAbsent('calculateButtonName', () => 'Додати\nзначення');
    ua.putIfAbsent('nanMessage', () => 'Результат не є числом');
    ua.putIfAbsent('nanData', () => 'Відсутні дані');
    ua.putIfAbsent('settings', () => 'Налаштування');
    ua.putIfAbsent('reset', () => 'Очистити\nдані');
    ua.putIfAbsent('show_grid', () => 'Відобразити сітку');
    ///ru
    ru.putIfAbsent('title', () => 'Вычисление наименьших квадратов');
    ru.putIfAbsent('calculateButtonName', () => 'Добавить\nзначения');
    ru.putIfAbsent('nanMessage', () => 'Is not a Number');
    ru.putIfAbsent('nanData', () => 'Нет данных');
    ru.putIfAbsent('settings', () => 'Настройки');
    ru.putIfAbsent('reset', () => 'Очистить\nданные');
    ru.putIfAbsent('show_grid', () => 'Показать сетку');

    _allTexts.putIfAbsent('en', () => en);
    _allTexts.putIfAbsent('zh', () => zh);
    _allTexts.putIfAbsent('hi', () => hi);
    _allTexts.putIfAbsent('es', () => es);
    _allTexts.putIfAbsent('de', () => de);
    _allTexts.putIfAbsent('fr', () => fr);
    _allTexts.putIfAbsent('pt', () => pt);
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
