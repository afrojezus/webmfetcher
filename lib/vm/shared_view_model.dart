import 'dart:io';

import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';
import 'package:webmfetch/model/library_entity.dart';
import 'package:webmfetch/sources/type.dart';

class SharedViewModel extends BaseViewModel {
  WebMSource webMSource = WebMSource.fourchan;
  String title = "webm.fetch";
  List<String> pageNames = ["Library", "Explore"];
  List<LibraryEntity> library = <LibraryEntity>[];
  bool showAsList = false;

  init() async {
    await setDesktopWindowMinSize();
    await loadState();
    library.sort((a, b) =>
        b.time.millisecondsSinceEpoch - a.time.millisecondsSinceEpoch);
    notifyListeners();
  }

  Future<void> loadState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final _lib = prefs.getString("library");
      if (_lib != null) {
        library = LibraryEntity.decode(_lib);
      }
    } catch (e) {
      rethrow;
    }

    notifyListeners();
  }

  Future<void> saveState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("library", LibraryEntity.encode(library));
    } catch (e) {
      rethrow;
    }

    notifyListeners();
  }

  Future<void> deleteState() async {
    try {
      for (var element in library) {
        await File(element.filepath).delete();
      }
      library.clear();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove("library");
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> setDesktopWindowMinSize() async {
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      await DesktopWindow.setMinWindowSize(const Size(460, 600));
    }
  }

  setListView(bool n) {
    showAsList = n;
    notifyListeners();
  }
}
