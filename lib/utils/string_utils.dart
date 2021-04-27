class StringUtils{

  static String replaceCommaByDot(String source){
    String _res = '';
    _res = source.replaceAll(new RegExp(r','), '.');
    var _split = _res.split('.');
    if(_split.length > 1) _res = _split[0] + '.' + _split[1];
    if(source.length == 0) _res = '0';
    return _res;
  }

  static String replaceOneSymbol(String source, String replaceWhat, String replaceTo){
    String _res = source;
    var _split = source.split(replaceWhat);
    if(_split.length > 1) {
      _res = _split[0];
      for(int i = 1; i < _split.length; i++){
        _res += replaceTo + _split[i];
      }
    }
    return _res;
  }

  static addLeadNul(String source){
    String _checkString = source.substring(0, 1);
    if(_checkString == '.') return '0'+source;
    else return source;
  }

  static String normalizeNumberView(num source){
    final List<String> _threeZeroLiterals = ['', 'K', 'M', 'B', 'T'];
    String _res;
    if(source > 0.01) {
      _res = source.toString().split('000')[0];
      _res = _res + _threeZeroLiterals[source.toString().split('000').length - 1];
    } else {
      List<String> _splitted = source.toStringAsExponential().split('e');
      _res = '${_splitted[0]}${getPowSuperscript(int.parse(_splitted[1]))}';
    }
    return _res;
  }

  static String getPowSuperscript(int value){
    String _res = '';
    final _numbers = '⁰¹²³⁴⁵⁶⁷⁸⁹';
    final _str = value.abs().toString();
    if (value !=0){
      for(int i = 0; i < _str.length; i++){
        _res += _numbers.substring(int.parse(_str[i]), int.parse(_str[i]) + 1);
      }
      if(value < 0)
        _res = '⁻' + _res;
    }
    return _res;
  }

}