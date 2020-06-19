import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cs_monetization/ui/widgets/visualizar_tile.dart';
import 'package:flutter/material.dart';
import 'package:cs_monetization/blocs/cupom_bloc.dart';

class VisualizarTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: BlocProvider.of<CupomBloc>(context).outcupons,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return VisualizarTile(cupom: snapshot.data[index]);  
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}
