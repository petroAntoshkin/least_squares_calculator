import 'package:least_squares/models/language_model.dart';

class LanguagesMock {
  Map<int, LanguageModel> languges = Map();

  LanguagesMock(){
    languges[0] = LanguageModel(prefix: 'en', name: 'English');
    languges[1] = LanguageModel(prefix: 'de', name: 'Deutsch');
    languges[2] = LanguageModel(prefix: 'es', name: 'Español');
    languges[3] = LanguageModel(prefix: 'fr', name: 'Français');
    languges[4] = LanguageModel(prefix: 'ua', name: 'Укрїнська');
    languges[5] = LanguageModel(prefix: 'ru', name: 'Русский');
  }
}