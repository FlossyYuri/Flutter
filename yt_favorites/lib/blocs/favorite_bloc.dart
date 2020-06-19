import 'dart:async';
import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/subjects.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yt_favorites/models/video.dart';

class FavoriteBloc implements BlocBase {
  Map<String, Video> _favoritos = {};
  final _favController = BehaviorSubject<Map<String, Video>>(seedValue: {});
  Stream<Map<String, Video>> get outFav => _favController.stream;
  FavoriteBloc() {
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getKeys().contains("favoritos")) {
        _favoritos = json.decode(prefs.getString("favoritos")).map((k, v) {
          return MapEntry(k, Video.fromJson(v));
        }).cast<String, Video>();
        _favController.add(_favoritos);
      }
    });
  }
  void toogleFavorite(Video video) {
    if (_favoritos.containsKey(video.id))
      _favoritos.remove(video.id);
    else
      _favoritos[video.id] = video;
    _favController.sink.add(_favoritos);

    _saveData();
  }

  _saveData() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString("favoritos", json.encode(_favoritos));
    });
  }

  @override
  void dispose() {
    _favController.close();
  }
}
