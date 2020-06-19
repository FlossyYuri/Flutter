import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:yt_favorites/models/video.dart';
import 'package:yt_favorites/ui/api.dart';

class VideosBloc implements BlocBase {
  Api api;
  List<Video> videos;
  final StreamController _videosController = StreamController<List<Video>>();
  Stream get outVideos => _videosController.stream;

  final StreamController _searchController = StreamController<String>();
  Sink get inSearch => _searchController.sink;

  VideosBloc() {
    api = Api();
    _searchController.stream.listen(_search);
  }

  _search(search) async {
    if (search != null)
      videos = await api.seach(search);
    else
      videos += await api.nextPage();
    _videosController.sink.add(videos);
  }

  @override
  void dispose() {
    _videosController.close();
    _searchController.close();
  }
}
