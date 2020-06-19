import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cs_monetization/blocs/cupom_bloc.dart';
import 'package:cs_monetization/ui/screens/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(BlocProvider(
      bloc: CupomBloc(),
      child: MaterialApp(
        title: "CS - Monetization",
        debugShowCheckedModeBanner: false,
        home: Home(),
      )));
}
