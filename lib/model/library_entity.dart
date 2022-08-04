import 'dart:convert';

class LibraryEntity {
  final int id;
  final String thumb;
  final String filepath;
  final DateTime time;
  final String name;
  final String origin;

  LibraryEntity(
      {required this.id,
      required this.thumb,
      required this.filepath,
      required this.time,
      required this.name,
      required this.origin});

  factory LibraryEntity.fromJson(Map<String, dynamic> json) {
    return LibraryEntity(
        id: json['id'],
        thumb: json['thumb'],
        filepath: json['filepath'],
        time: DateTime.parse(json['time']),
        name: json['name'],
        origin: json['origin']);
  }

  static Map<String, dynamic> toMap(LibraryEntity e) => {
        "id": e.id,
        "thumb": e.thumb,
        "filepath": e.filepath,
        "time": e.time.toIso8601String(),
        "name": e.name,
        "origin": e.origin
      };

  static String encode(List<LibraryEntity> items) => json.encode(items
      .map<Map<String, dynamic>>((entity) => LibraryEntity.toMap(entity))
      .toList());

  static List<LibraryEntity> decode(String items) =>
      (json.decode(items) as List<dynamic>)
          .map<LibraryEntity>((e) => LibraryEntity.fromJson(e))
          .toList();
}
