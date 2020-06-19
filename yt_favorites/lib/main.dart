import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yt_favorites/blocs/favorite_bloc.dart';
import 'package:yt_favorites/blocs/videos_bloc.dart';
import 'package:yt_favorites/ui/home.dart';

void main() {
  runApp(BlocProvider(
      bloc: VideosBloc(),
      child: BlocProvider(
        bloc: FavoriteBloc(),
        child: MaterialApp(
          title: "Youtube Favoritos",
          home: Home(),
          debugShowCheckedModeBanner: false,
        ),
      )));
}
