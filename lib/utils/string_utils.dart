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

}