class StringUtils{

  static String normalizeDouble(String source){
    String _res = '';
    _res = source.replaceAll(new RegExp(r','), '.');
    var _split = _res.split('.');
    if(_split.length > 1) _res = _split[0] + '.' + _split[1];
    return _res;
  }
}