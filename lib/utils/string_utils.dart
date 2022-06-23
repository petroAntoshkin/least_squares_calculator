class StringUtils {
  static String replaceCommaByDot(String source) {
    String _res = '';
    _res = source.replaceAll(new RegExp(r','), '.');
    var _split = _res.split('.');
    if (_split.length > 1) _res = _split[0] + '.' + _split[1];
    if (source.length == 0) _res = '0';
    return _res;
  }

  static String replaceOneSymbol(
      String source, String replaceWhat, String replaceTo) {
    String _res = source;
    var _split = source.split(replaceWhat);
    if (_split.length > 1) {
      _res = _split[0];
      for (int i = 1; i < _split.length; i++) {
        _res += replaceTo + _split[i];
      }
    }
    return _res;
  }

  static addLeadNul(String source) {
    String _checkString = source.substring(0, 1);
    if (_checkString == '.')
      return '0' + source;
    else
      return source;
  }

  static String normalizeNumberView(num source) {
    if (source.abs() <= 0.001 || source.abs() >= 1000) {
      List<String> _splitted = source.toStringAsExponential().split('e');
      String _res =
          '${_splitted[0]}${getPowSuperscript(int.parse(_splitted[1]))}';
      return _res;
    } else
      return source.toString();
  }

  static String prettifyDouble(String base, int pow) {
    String _res = pow < 0 ? '0.' : '';
    for (int i = 0; i != pow; i += pow > 0 ? 1 : -1) {
      _res += '0';
    }
    return pow > 0 ? '$base$_res' : '$_res$base';
  }

  static String doubleShift({double doubleBase, int powValue}) {
    if (powValue == 0 || doubleBase == 0) {
      return '$doubleBase';
    }
    String right, left, result;
    var tt = '$doubleBase'.split('.');
    left = tt[0];
    right = tt[1];
    if (powValue > 0) {
      if(right.length < powValue) {
        for (int i = right.length; i < powValue; i++) {
          right = '${right}0';
        }
      }
      result = '$left${right.substring(0, powValue)}.${right.substring(powValue)}';
    }
    if(powValue < 0){
      if(left.length < powValue.abs()) {
        for (int i = left.length; i < powValue.abs(); i++) {
          left = '0$left';
        }
      }
      result = '${left.substring(-powValue)}.${left.substring(0, -powValue)}$right';
    }
    return result;
  }

  static String getPowSuperscript(int value) {
    String _res = '';
    final _numbers = '⁰¹²³⁴⁵⁶⁷⁸⁹';
    final _str = value.abs().toString();
    if (value != 0) {
      for (int i = 0; i < _str.length; i++) {
        _res += _numbers.substring(int.parse(_str[i]), int.parse(_str[i]) + 1);
      }
      if (value < 0) _res = '⁻' + _res;
    }
    return _res;
  }
}
