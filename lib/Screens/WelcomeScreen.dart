import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  final Function selectScreen;
  WelcomeScreen({Key key, this.selectScreen}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 3)).then((value) {
      widget.selectScreen();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Theme.of(context).primaryColor.withOpacity(.7), Theme.of(context).primaryColor.withOpacity(1),]
              )
            ),
          ),
          Align(
            alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TweenAnimationBuilder(
                    tween: Tween<double>(
                      begin: 0.3,
                      end: 1.0,
                    ),
                    curve: Curves.bounceOut,
                    duration: Duration(milliseconds: 800),
                    builder: (context, scale, child){
                      return Transform.scale(
                          scale: scale,
                          child: child,
                      );
                    },
                    child: Image(
                      image: AssetImage('Assets/calendar.png',),
                      height: 110,
                    ),
                  ),
                  Text('DAILY TODO', style: TextStyle(fontSize: 36.0, color: Colors.white, fontWeight: FontWeight.w700),),
                ],
              ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text('from', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Roboto', fontSize: 24.0, color: Colors.white70,),),
                  SizedBox(height: 5.0,),
                  Text('LEGACY LLC', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Roboto', fontSize: 24.0, color: Colors.white,),),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}

