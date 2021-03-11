import 'dart:convert';

class SettingsModel{
  String language;
  bool showGrid;
  int themeId;
  SettingsModel({this.language, this.showGrid, this.themeId});


  String toString() {
    return '{"language": "$language", "show_grid": "$showGrid", "theme_id":"$themeId"}';
  }

  void parseJson(String contents){
    this.language = json.decode(contents)['language'];
    this.showGrid = json.decode(contents)['show_grid'] == 'true';
    this.themeId = int.parse(json.decode(contents)['theme_id']);
    if(this.themeId == null)
      this.themeId = 0;
  }
}