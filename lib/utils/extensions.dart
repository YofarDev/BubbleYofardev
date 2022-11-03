

extension AppString on String {
  bool isValidEmail() {
    return RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$',
    ).hasMatch(this);
  }


  String get capitalize => toUpperCase();

  String maxLength(int max, {bool addEllipsis = true}) {
    final int length = this.length;
    if (max >= length) {
      return this;
    } else {
      if (addEllipsis) {
        return "${substring(0, max)}...";
      } else {
        return substring(0, max);
      }
    }
  }

  String toRedLog() => "'\x1B[31m$this\x1B[0m'";
  String toGreenLog() => "'\x1B[32m$this\x1B[0m'";
  String toYellowLog() => "'\x1B[33m$this\x1B[0m'";
  String toBlueLog() => "'\x1B[34m$this\x1B[0m'";

  bool isNumeric() {
    final RegExp numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');

    return numericRegex.hasMatch(this);
  }
}

extension InvertMap<K, V> on Map<K, V> {
  Map<V, K> get mapInversed => Map<V, K>.fromEntries(
        entries.map(
          (MapEntry<K, V> e) => MapEntry<V, K>(e.value, e.key),
        ),
      );
}

// To convert Map from firestore
extension MapUtils on Map<String, dynamic> {
  Map<String, String> toStringMap() => map(
        (String key, dynamic value) =>
            MapEntry<String, String>(key, value as String),
      );
}
