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
    Map<String, String> it = new Map();
    Map<String, String> pl = new Map();
    Map<String, String> ua = new Map();
    Map<String, String> ru = new Map();
    ///en
    en.putIfAbsent('title', () => 'Least Squares Calculator');
    en.putIfAbsent('nanMessage', () => 'Not enough data');
    en.putIfAbsent('nanData', () => 'No data');
    en.putIfAbsent('settings', () => 'Settings');
    en.putIfAbsent('default_settings', () => 'Default settings');
    en.putIfAbsent('reset', () => 'Reset data');
    en.putIfAbsent('show_grid', () => 'Show grid');
    en.putIfAbsent('del_approve', () => 'Are you sure? you can\'t undo this action');
    en.putIfAbsent('cancel', () => 'Cancel');
    en.putIfAbsent('delete', () => 'Delete');
    en.putIfAbsent('dots_size', () => 'Dots size');
    en.putIfAbsent('export', () => 'Export image');
    en.putIfAbsent('no_images', () => 'No images');
    en.putIfAbsent('delete_image', () => 'Images deleting');
    en.putIfAbsent('copy_image_path', () => 'Copy Image path');
    en.putIfAbsent('customization', () => 'Customization');
    en.putIfAbsent('axis_description', () => 'Axis description');
    en.putIfAbsent('equal_data_error_1', () => 'Only one value of Y must correspond to one value of X.');
    en.putIfAbsent('equal_data_error_2', () => 'Such data already exist');
    ///zh
    zh.putIfAbsent('title', () => '最小二乘');
    zh.putIfAbsent('nanMessage', () => '资料不足');
    zh.putIfAbsent('nanData', () => '沒有數據');
    zh.putIfAbsent('settings', () => '設定值');
    zh.putIfAbsent('default_settings', () => '默认设置');
    zh.putIfAbsent('reset', () => '重置數據');
    zh.putIfAbsent('show_grid', () => '顯示網格');
    zh.putIfAbsent('del_approve', () => '你確定嗎？ 您無法撤消此操作');
    zh.putIfAbsent('cancel', () => '取消');
    zh.putIfAbsent('delete', () => '刪除');
    zh.putIfAbsent('dots_size', () => '點尺寸');
    zh.putIfAbsent('export', () => '匯出圖片');
    zh.putIfAbsent('no_images', () => '沒有圖片');
    zh.putIfAbsent('delete_image', () => '图片删除');
    zh.putIfAbsent('copy_image_path', () => '复制影像');
    zh.putIfAbsent('customization', () => '客制化');
    zh.putIfAbsent('axis_description', () => '轴说明');
    zh.putIfAbsent('equal_data_error_1', () => 'Y的两个或多个值不可能对应于X的一个值。');
    zh.putIfAbsent('equal_data_error_2', () => '这样的数据已经存在');
    ///hi
    hi.putIfAbsent('title', () => 'कम से कम दो गुना');
    hi.putIfAbsent('nanMessage', () => 'पर्याप्त डेटा नहीं');
    hi.putIfAbsent('nanData', () => 'कोई आकड़ा उपलब्ध नहीं है');
    hi.putIfAbsent('settings', () => 'समायोजन');
    hi.putIfAbsent('default_settings', () => 'न्यूनता समायोजन');
    hi.putIfAbsent('reset', () => 'रीसेट डेटा');
    hi.putIfAbsent('show_grid', () => 'ग्रिड दिखाएं');
    hi.putIfAbsent('del_approve', () => 'क्या आपको यकीन है? आप इस क्रिया को पूर्ववत नहीं कर सकते');
    hi.putIfAbsent('cancel', () => 'रद्द करना');
    hi.putIfAbsent('delete', () => 'हटाएं');
    hi.putIfAbsent('dots_size', () => 'डॉट्स का आकार');
    hi.putIfAbsent('export', () => 'निर्यात छवि');
    hi.putIfAbsent('no_images', () => 'कोई चित्र नहीं');
    hi.putIfAbsent('delete_image', () => 'चित्र हटाना');
    hi.putIfAbsent('copy_image_path', () => 'छवि पथ की प्रतिलिपि बनाएँ');
    hi.putIfAbsent('customization', () => 'अनुकूलन');
    hi.putIfAbsent('axis_description', () => 'एक्सिस विवरण');
    hi.putIfAbsent('equal_data_error_1', () => 'X के एक मान से Y के दो या अधिक मान संभव नहीं हैं।');
    hi.putIfAbsent('equal_data_error_2', () => 'ऐसा डेटा पहले से मौजूद है');
    ///es
    es.putIfAbsent('title', () => 'Mínimos cuadrados');
    es.putIfAbsent('nanMessage', () => 'No hay suficientes datos');
    es.putIfAbsent('nanData', () => 'Sin datos');
    es.putIfAbsent('settings', () => 'Configuración');
    es.putIfAbsent('default_settings', () => 'Configuraciones predeterminadas');
    es.putIfAbsent('reset', () => 'Reiniciar datos');
    es.putIfAbsent('show_grid', () => 'Mostrar cuadrícula');
    es.putIfAbsent('del_approve', () => '¿Está seguro? no puedes deshacer esta acción');
    es.putIfAbsent('cancel', () => 'Cancelar');
    es.putIfAbsent('delete', () => 'Borrar');
    es.putIfAbsent('dots_size', () => 'Tamaño de los puntos');
    es.putIfAbsent('export', () => 'Exporter l\'image');
    es.putIfAbsent('no_images', () => 'Sin imágenes');
    es.putIfAbsent('delete_image', () => 'Eliminación de imágenes');
    es.putIfAbsent('copy_image_path', () => 'Copiar ruta de imagen');
    es.putIfAbsent('customization', () => 'Personalización');
    es.putIfAbsent('axis_description', () => 'Descripción del eje');
    es.putIfAbsent('equal_data_error_1', () => 'No es posible que dos o más valores de Y correspondan a un valor de X.');
    es.putIfAbsent('equal_data_error_2', () => 'Tales datos ya existen');
    ///fr
    fr.putIfAbsent('title', () => 'Méthode des moindres carrés');
    fr.putIfAbsent('nanMessage', () => 'Pas assez de données');
    fr.putIfAbsent('nanData', () => 'Aucune donnée');
    fr.putIfAbsent('settings', () => 'Paramètres');
    fr.putIfAbsent('default_settings', () => 'Paramètres par défaut');
    fr.putIfAbsent('reset', () => 'Réinitialiser données');
    fr.putIfAbsent('show_grid', () => 'Afficher la grille');
    fr.putIfAbsent('del_approve', () => 'Êtes-vous sûr? vous ne pouvez pas annuler cette action');
    fr.putIfAbsent('cancel', () => 'Annuler');
    fr.putIfAbsent('delete', () => 'Effacer');
    fr.putIfAbsent('dots_size', () => 'Taille des points');
    fr.putIfAbsent('export', () => 'Export image');
    fr.putIfAbsent('no_images', () => 'Aucune image');
    fr.putIfAbsent('delete_image', () => 'Suppression d\'images');
    fr.putIfAbsent('copy_image_path', () => 'Copier le chemin de l\'image');
    fr.putIfAbsent('customization', () => 'Personnalisation');
    fr.putIfAbsent('axis_description', () => 'Description de l\'axe');
    fr.putIfAbsent('equal_data_error_1', () => 'Il est impossible que deux ou plusieurs valeurs de Y correspondent à une valeur de X.');
    fr.putIfAbsent('equal_data_error_2', () => 'De telles données existent déjà');
    ///de
    de.putIfAbsent('title', () => 'Kleinsten Quadrate');
    de.putIfAbsent('nanMessage', () => 'Nicht genügend Daten');
    de.putIfAbsent('nanData', () => 'Keine Daten');
    de.putIfAbsent('settings', () => 'die Einstellungen');
    de.putIfAbsent('default_settings', () => 'Standardeinstellungen');
    de.putIfAbsent('reset', () => 'Daten zurücksetzen');
    de.putIfAbsent('show_grid', () => 'Rasteranzeige');
    de.putIfAbsent('del_approve', () => 'Sind Sie sicher? Sie können diese Aktion nicht rückgängig machen');
    de.putIfAbsent('cancel', () => 'Stornieren');
    de.putIfAbsent('delete', () => 'Löschen');
    de.putIfAbsent('dots_size', () => 'Punktgröße');
    de.putIfAbsent('export', () => 'Bild exportieren');
    de.putIfAbsent('no_images', () => 'Keine Bilder');
    de.putIfAbsent('delete_image', () => 'Löschen von Bildern');
    de.putIfAbsent('copy_image_path', () => 'Bildpfad kopieren');
    de.putIfAbsent('customization', () => 'Anpassung');
    de.putIfAbsent('axis_description', () => 'Achsenbeschreibung');
    de.putIfAbsent('equal_data_error_1', () => 'Nicht möglich, dass zwei oder mehr Werte von Y einem Wert von X entsprechen.');
    de.putIfAbsent('equal_data_error_2', () => 'Solche Daten existieren bereits');
    ///pt
    pt.putIfAbsent('title', () => 'Mínimos quadrados');
    pt.putIfAbsent('nanMessage', () => 'Não há dados suficientes');
    pt.putIfAbsent('nanData', () => 'Sem dados');
    pt.putIfAbsent('settings', () => 'Configurações');
    pt.putIfAbsent('default_settings', () => 'Configurações padrão');
    pt.putIfAbsent('reset', () => 'Redefinir dados');
    pt.putIfAbsent('show_grid', () => 'Mostre as grades');
    pt.putIfAbsent('del_approve', () => 'Tem certeza? você não pode desfazer esta ação');
    pt.putIfAbsent('cancel', () => 'Cancelar');
    pt.putIfAbsent('delete', () => 'Excluir');
    pt.putIfAbsent('dots_size', () => 'Tamanho dos pontos');
    pt.putIfAbsent('export', () => 'Exportar imagem');
    pt.putIfAbsent('no_images', () => 'Sem imagens');
    pt.putIfAbsent('delete_image', () => 'Excluindo imagens');
    pt.putIfAbsent('copy_image_path', () => 'Copiar caminho da imagem');
    pt.putIfAbsent('customization', () => 'Costumização');
    pt.putIfAbsent('axis_description', () => 'Descrição do eixo');
    pt.putIfAbsent('equal_data_error_1', () => 'Não é possível que dois ou mais valores de Y correspondam a um valor de X.');
    pt.putIfAbsent('equal_data_error_2', () => 'Esses dados já existem');
    ///it
    it.putIfAbsent('title', () => 'Calcolatrice dei minimi quadrati');
    it.putIfAbsent('nanMessage', () => 'Dati insufficienti');
    it.putIfAbsent('nanData', () => 'Nessun dato');
    it.putIfAbsent('settings', () => 'Impostazioni');
    it.putIfAbsent('default_settings', () => 'Impostazioni predefinite');
    it.putIfAbsent('reset', () => 'Reimposta i dati');
    it.putIfAbsent('show_grid', () => 'Mostra griglia');
    it.putIfAbsent('del_approve', () => 'Sei sicuro? Non puoi annullare questa azione');
    it.putIfAbsent('cancel', () => 'Annulla');
    it.putIfAbsent('delete', () => 'Elimina');
    it.putIfAbsent('dots_size', () => 'Dimensione dei punti');
    it.putIfAbsent('export', () => 'Esporta immagine');
    it.putIfAbsent('no_images', () => 'Nessuna immagine');
    it.putIfAbsent('delete_image', () => 'Eliminazione delle immagini');
    it.putIfAbsent('copy_image_path', () => 'Copia percorso immagine');
    it.putIfAbsent('customization', () => 'Personalizzazione');
    it.putIfAbsent('axis_description', () => 'Descrizione dell\'asse');
    it.putIfAbsent('equal_data_error_1', () => 'Un solo valore di Y deve corrispondere a un valore di X.');
    it.putIfAbsent('equal_data_error_2', () => 'Tali dati esistono già');
    ///pl
    pl.putIfAbsent('title', () => 'Kalkulator najmniejszych kwadratów');
    pl.putIfAbsent('nanMessage', () => 'Za mało danych');
    pl.putIfAbsent('nanData', () => 'Brak danych');
    pl.putIfAbsent('settings', () => 'Ustawienia');
    pl.putIfAbsent('default_settings', () => 'Ustawienia domyślne');
    pl.putIfAbsent('reset', () => 'Resetuj dane');
    pl.putIfAbsent('show_grid', () => 'Pokaż siatkę');
    pl.putIfAbsent('del_approve', () => 'Jesteś pewny? Nie możesz cofnąć tej czynności');
    pl.putIfAbsent('cancel', () => 'Odwołać');
    pl.putIfAbsent('delete', () => 'Usunąć');
    pl.putIfAbsent('dots_size', () => 'Rozmiar kropek');
    pl.putIfAbsent('export', () => 'Eksport obrazu');
    pl.putIfAbsent('no_images', () => 'Brak obrazów');
    pl.putIfAbsent('delete_image', () => 'Usuwanie obrazów');
    pl.putIfAbsent('copy_image_path', () => 'Kopiuj ścieżkę obrazu');
    pl.putIfAbsent('customization', () => 'Dostosowywanie');
    pl.putIfAbsent('axis_description', () => 'Opis osi');
    pl.putIfAbsent('equal_data_error_1', () => 'Tylko jedna wartość Y musi odpowiadać jednej wartości X.');
    pl.putIfAbsent('equal_data_error_2', () => 'Takie dane już istnieją');
    ///ua
    ua.putIfAbsent('title', () => 'Обчислення найменших квадратів');
    ua.putIfAbsent('nanMessage', () => 'Недостатньо даних');
    ua.putIfAbsent('nanData', () => 'Відсутні дані');
    ua.putIfAbsent('settings', () => 'Налаштування');
    ua.putIfAbsent('default_settings', () => 'Налаштування за замовчуванням');
    ua.putIfAbsent('reset', () => 'Очистити дані');
    ua.putIfAbsent('show_grid', () => 'Відобразити сітку');
    ua.putIfAbsent('del_approve', () => 'Ви впевнені? Цю дію не можна скасувати');
    ua.putIfAbsent('cancel', () => 'Скасувати');
    ua.putIfAbsent('delete', () => 'Видалити');
    ua.putIfAbsent('dots_size', () => 'Розмір точок');
    ua.putIfAbsent('export', () => 'Експортувати зображення');
    ua.putIfAbsent('no_images', () => 'Немає зображень');
    ua.putIfAbsent('delete_image', () => 'Видалення зображень');
    ua.putIfAbsent('copy_image_path', () => 'Скопіювати шлях зображення');
    ua.putIfAbsent('customization', () => 'Налаштування');
    ua.putIfAbsent('axis_description', () => 'Підпис вісі');
    ua.putIfAbsent('equal_data_error_1', () => 'Неможливо, щоб два або більше значень Y відповідали одному значенню X.');
    ua.putIfAbsent('equal_data_error_2', () => 'Такі дані вже існують');
    ///ru
    ru.putIfAbsent('title', () => 'Вычисление наименьших квадратов');
    ru.putIfAbsent('nanMessage', () => 'Недостаточно данных');
    ru.putIfAbsent('nanData', () => 'Нет данных');
    ru.putIfAbsent('settings', () => 'Настройки');
    ru.putIfAbsent('default_settings', () => 'Настройки по умолчанию');
    ru.putIfAbsent('reset', () => 'Очистить данные');
    ru.putIfAbsent('show_grid', () => 'Показать сетку');
    ru.putIfAbsent('del_approve', () => 'Вы уверены?');
    ru.putIfAbsent('cancel', () => 'Отменить');
    ru.putIfAbsent('delete', () => 'Удалить');
    ru.putIfAbsent('dots_size', () => 'Размер точек');
    ru.putIfAbsent('export', () => 'Экспорт изображения');
    ru.putIfAbsent('no_images', () => 'Нет изображений');
    ru.putIfAbsent('delete_image', () => 'Удаление изображений');
    ru.putIfAbsent('copy_image_path', () => 'Копировать путь изображения');
    ru.putIfAbsent('customization', () => 'Настройка');
    ru.putIfAbsent('axis_description', () => 'Описание оси');
    ru.putIfAbsent('equal_data_error_1', () => 'Нельзя, чтобы два или более значения Y соответствовали одному значению X.');
    ru.putIfAbsent('equal_data_error_2', () => 'Уже есть такие данные');

    _allTexts.putIfAbsent('en', () => en);
    _allTexts.putIfAbsent('zh', () => zh);
    _allTexts.putIfAbsent('hi', () => hi);
    _allTexts.putIfAbsent('es', () => es);
    _allTexts.putIfAbsent('de', () => de);
    _allTexts.putIfAbsent('fr', () => fr);
    _allTexts.putIfAbsent('pt', () => pt);
    _allTexts.putIfAbsent('it', () => it);
    _allTexts.putIfAbsent('pl', () => pl);
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
  bool isLanguageAvailable(String lang){
    return _allTexts[lang] != null;
  }

}
