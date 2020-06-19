import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:yt_favorites/delegates/data_search.dart';
import 'package:yt_favorites/blocs/videos_bloc.dart';
import 'package:yt_favorites/blocs/favorite_bloc.dart';
import 'package:yt_favorites/models/video.dart';
import 'package:yt_favorites/ui/favorites.dart';
import 'package:yt_favorites/widget/video_tile.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<VideosBloc>(context);
    final blocF = BlocProvider.of<FavoriteBloc>(context);
    return Scaffold(
        appBar: AppBar(
          title: Container(
            alignment: Alignment.centerLeft,
            child: Image.asset(
              "assets/yt_logo.png",
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.black87,
          actions: <Widget>[
            Align(
              alignment: Alignment.center,
              child: StreamBuilder<Map<String, Video>>(
                stream: blocF.outFav,
                builder: (context, snapshot){
                  if(snapshot.hasData) return Text("${snapshot.data.length}");
                  else return Container();
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.favorite),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => Favorites()));
              },
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                String resultado =
                    await showSearch(context: context, delegate: DataSearch());
                if (resultado != null) bloc.inSearch.add(resultado);
              },
            ),
          ],
        ),
        backgroundColor: Colors.black87,
        body: StreamBuilder(
          stream: bloc.outVideos,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  if (index < snapshot.data.length) {
                    return VideoTile(snapshot.data[index]);
                  } else {
                    bloc.inSearch.add(null);
                    return Container(
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    );
                  }
                },
                itemCount: snapshot.data.length + 1,
              );
            } else {
              return Container();
            }
          },
        ));
  }
}
