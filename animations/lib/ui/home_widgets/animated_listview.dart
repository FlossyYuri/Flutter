import 'package:animations/ui/home_widgets/list_data.dart';
import 'package:flutter/material.dart';

class AnimatedListView extends StatelessWidget {
  final Animation<EdgeInsets> listSlidePosition;
  AnimatedListView({@required this.listSlidePosition});
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        ListData(
          titulo: "Estudar Flutter",
          subtitulo: "Com o curso de Daniel Ciofi",
          imagem: AssetImage("assets/perfil.png"),
          margem: listSlidePosition.value * 5,
        ),
        ListData(
          titulo: "Criar App gestor",
          subtitulo: "Depois de terminar o curso",
          imagem: AssetImage("assets/perfil.png"),
          margem: listSlidePosition.value * 4,
        ),
        ListData(
          titulo: "Estudar Flutter",
          subtitulo: "Com o curso de Daniel Ciofi",
          imagem: AssetImage("assets/perfil.png"),
          margem: listSlidePosition.value * 3,
        ),
        ListData(
          titulo: "Criar App gestor",
          subtitulo: "Depois de terminar o curso",
          imagem: AssetImage("assets/perfil.png"),
          margem: listSlidePosition.value * 2,
        ),
        ListData(
          titulo: "Estudar Flutter",
          subtitulo: "Com o curso de Daniel Ciofi",
          imagem: AssetImage("assets/perfil.png"),
          margem: listSlidePosition.value * 1,
        ),
        ListData(
          titulo: "Criar App gestor",
          subtitulo: "Depois de terminar o curso",
          imagem: AssetImage("assets/perfil.png"),
          margem: listSlidePosition.value * 0,
        ),
      ],
    );
  }
}
