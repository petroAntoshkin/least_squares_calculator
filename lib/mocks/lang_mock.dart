import 'package:least_squares/models/language_model.dart';

class LanguagesMock {
  Map<int, LanguageModel> languges = Map();

  LanguagesMock(){
    languges[0] = LanguageModel(prefix: 'en', name: 'English');
    languges[1] = LanguageModel(prefix: 'zh', name: '中文');
    languges[2] = LanguageModel(prefix: 'hi', name: 'हिन्दी');
    languges[3] = LanguageModel(prefix: 'es', name: 'Español');
    languges[4] = LanguageModel(prefix: 'fr', name: 'Français');
    languges[5] = LanguageModel(prefix: 'de', name: 'Deutsch');
    languges[6] = LanguageModel(prefix: 'pt', name: 'Português');
    languges[7] = LanguageModel(prefix: 'uk', name: 'Українська');
    languges[8] = LanguageModel(prefix: 'pl', name: 'Polski');
    // languges[7] = LanguageModel(prefix: 'it', name: 'Italiano');
    // languges[8] = LanguageModel(prefix: 'pl', name: 'Polskie');
    // languges[9] = LanguageModel(prefix: 'ua', name: 'Українська');
    // languges[10] = LanguageModel(prefix: 'ru', name: 'Русский');


  }
}