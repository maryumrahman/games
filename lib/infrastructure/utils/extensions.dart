import 'package:flutter/material.dart';

extension ColorExtension on Color {
  Color op(double op) => withValues(alpha: op);
}

extension MediaQueryExtenstion on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;

  double get screenHeight => MediaQuery.sizeOf(this).height;

  Orientation get orientation => MediaQuery.orientationOf(this);

  TextTheme get textTheme => Theme.of(this).textTheme;

  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => theme.colorScheme;
}

extension WrapSpace on Widget {
  Widget space({double? height, double? width}) => SizedBox(
    height: height,
    width: width,
    child: this,
  );
}

extension Space on num {
  SizedBox get height => SizedBox(height: toDouble());

  SizedBox get width => SizedBox(width: toDouble());
}
extension StringNullExtensions on String? {
  String? get nullIfEmpty {
    if (this != null) {
      if (this is String && (this as String).isEmpty) {
        return null;
      } else {
        return this;
      }
    } else {
      return null;
    }
  }
}

extension StringExtensions on String {
  bool get isEmail {
    return RegExp(
        r"^[a-z0-9_\+-]+(\.[a-z0-9_\+-]+)*@[a-z0-9-]+(\.[a-z0-9-]+)*\.[a-z]{2,}$")
        .hasMatch(toLowerCase());
  }

  bool get isNumber {
    RegExp priceRegex = RegExp(r'^\d+$');
    return priceRegex.hasMatch(this);
  }

  bool get isValidPrice {
    RegExp priceRegex = RegExp(r'^\$?\d+(\.\d{1,2})?$');

    return priceRegex.hasMatch(this);
  }

  bool get isValidPostalCode {
    final List<RegExp> patterns = [
      RegExp(r'^\d{5}(-\d{4})?$'),
      RegExp(r'^[A-Za-z]\d[A-Za-z] ?\d[A-Za-z]\d$'),
      RegExp(r'^\d{5}$'),
      RegExp(r'^\d{6}$'),
      RegExp(r'^\d{4}$'),
    ];


    return patterns.any((regex) => regex.hasMatch(this));
  }

  bool get isURL {
    String str = this;

    if (str.isEmpty || str.length > 2083 || str.startsWith('mailto:')) {
      return false;
    }

    final options = {
      'protocols': ['http', 'https', 'ftp'],
      'require_tld': true,
      'require_protocol': false,
      'allow_underscores': false,
    };

    // Check protocol
    var split = str.split('://');
    if (split.length > 1) {
      final protocol = shift(split);
      final protocols = options['protocols'] as List<String>;
      if (!protocols.contains(protocol)) {
        return false;
      }
    } else if (options['require_protocol'] == true) {
      return false;
    }
    str = split.join('://');

    // Check hash
    split = str.split('#');
    str = shift(split) ?? '';
    final hash = split.join('#');
    if (hash.isNotEmpty && RegExp(r'\s').hasMatch(hash)) {
      return false;
    }

    // Check query params
    split = str.split('?');
    str = shift(split) ?? '';
    final query = split.join('?');
    if (query.isNotEmpty && RegExp(r'\s').hasMatch(query)) {
      return false;
    }

    // Check path
    split = str.split('/');
    str = shift(split) ?? '';
    final path = split.join('/');
    if (path.isNotEmpty && RegExp(r'\s').hasMatch(path)) {
      return false;
    }

    // Check auth type URLs
    split = str.split('@');
    if (split.length > 1) {
      final auth = shift(split);
      if (auth != null && auth.contains(':')) {
        final parts = auth.split(':');
        final user = shift(parts);
        if (user == null || !RegExp(r'^\S+$').hasMatch(user)) {
          return false;
        }
        final pass = parts.join(':');
        if (!RegExp(r'^\S*$').hasMatch(pass)) {
          return false;
        }
      }
    }

    // Check hostname and port
    final hostname = split.join('@');
    split = hostname.split(':');
    if (split.length > 1) {
      final portStr = split.last;
      final port = int.tryParse(portStr);
      if (!RegExp(r'^[0-9]+$').hasMatch(portStr) || port == null || port <= 0 ||
          port > 65535) {
        return false;
      }
    }

    return true;
  }

  String? shift(List<String> elements) {
    if (elements.isEmpty) return null;
    return elements.removeAt(0);
  }
}
