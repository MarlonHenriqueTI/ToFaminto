import 'dart:convert';

class Filter {
  /// The unique database identifier
  final id;

  /// The name that will be displayed on the app
  final name;

  /// Type can be any of those:
  ///
  /// food
  ///
  /// timespan
  ///
  /// misc
  final type;

  Filter(this.id, this.name, this.type);

  factory Filter.fromJson(Map<String, dynamic> json) {
    return Filter(
      json['id'],
      json['name'],
      json['type'],
    );
  }

  toJson() {
    return jsonEncode({
      "id": id,
      "name": name,
      "type": type,
    });
  }
}
