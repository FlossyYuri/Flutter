import 'package:flutter/material.dart';
class LogoApp extends StatefulWidget {
  LogoApp({Key key}) : super(key: key);
  _LogoAppState createState() => _LogoAppState();
}

class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;
  @override
  void initState() {
    super.initState();

    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2));

    animation = CurvedAnimation(parent: controller, curve: Curves.easeInOut)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlossyTransition(
      child: LogoWidget(),
      animation: animation,
    );
  }
}

// class AnimatedLogo extends AnimatedWidget {
//   AnimatedLogo(Animation<double> animation) : super(listenable: animation);

//   @override
//   Widget build(BuildContext context) {
//     Animation<double> animation = listenable;
//     return Center(
//       child: Container(
//         height: animation.value,
//         width: animation.value,
//         child: FlutterLogo(),
//       ),
//     );
//   }
// }

class LogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlutterLogo(),
    );
  }
}

class FlossyTransition extends StatelessWidget {
  final Widget child;
  final Animation<double> animation;
  final sizeTween = Tween<double>(begin: 0, end: 300);
  final opacityTween = Tween<double>(begin: 0.1, end: 1);
  FlossyTransition({this.child, this.animation});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: animation,
        builder: (context, child) {
          return Opacity(
            child: Container(
              height: sizeTween.evaluate(animation).clamp(0.0, 1000.0),
              width: sizeTween.evaluate(animation).clamp(0.0, 1000.0),
              child: child,
            ),
            opacity: opacityTween.evaluate(animation).clamp(0.0, 1.0),
          );
        },
        child: child,
      ),
    );
  }
}
