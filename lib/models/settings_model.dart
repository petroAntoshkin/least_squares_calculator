import 'dart:convert';

class SettingsModel{
  String language;
  bool showGrid;
  bool sortByX;
  int themeId;
  SettingsModel({required this.language, required this.showGrid, required this.sortByX, required this.themeId});


  String toString() {
    return '{"language": "$language", "show_grid": "$showGrid", "sort": "$sortByX", "theme_id":"$themeId"}';
  }

  void parseJson(String contents){
    this.language = json.decode(contents)['language'];
    this.showGrid = json.decode(contents)['show_grid'] == 'true';
    this.sortByX = json.decode(contents)['sort'] == 'true';
    this.themeId = int.parse(json.decode(contents)['theme_id']);
    // if(this.themeId == null)
    //   this.themeId = 0;
  }
}