import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:cs_monetization/blocs/cupom_bloc.dart';

class EstatisticasTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<String>>(
      stream: BlocProvider.of<CupomBloc>(context).outestats,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              if (snapshot.data[index].length > 0)
                return ListTile(
                  trailing: Text(
                    snapshot.data[index]
                        .substring(0, snapshot.data[index].indexOf(":")),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(195, 55, 100, 1),
                    ),
                  ),
                  leading: Text(
                    snapshot.data[index]
                        .substring(snapshot.data[index].indexOf(":") + 1),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(195, 55, 100, 1),
                    ),
                  ),
                );
              return Container(); 
            },
          );
        } else {
          return Container();
        }
      },
    );
  }
}
