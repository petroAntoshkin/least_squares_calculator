import 'dart:convert';

class SettingsModel{
  String language;
  String theme;
  bool showGrid;
  SettingsModel({this.language, this.theme, this.showGrid});


  String toString() {
    return '{"language": "$language", "theme": "$theme", "show_grid": "$showGrid"}';
  }

  void parseJson(String contents){
    this.language = json.decode(contents)['language'];
    this.theme = json.decode(contents)['theme'];
    this.showGrid = json.decode(contents)['show_grid'] == 'true';
  }
}