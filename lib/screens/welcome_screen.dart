import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../components/padding_button.dart';

class WelcomeScreen extends StatefulWidget {

  static const String id = "welcome_screen";

  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {

  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = AnimationController(
        duration: Duration(seconds: 1),
        vsync: this,
    );
    animation = ColorTween(
      begin: Colors.blueGrey, end: Colors.white
    ).animate(controller);
    controller.forward();
    controller.addListener(
        (){
          setState(() {});
        }
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: [
                Hero(
                  tag: "logo",
                  child: Container(
                    height: 60,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
                SizedBox(
                  child: DefaultTextStyle(
                      style: TextStyle(
                        fontSize: 45.0,
                        fontWeight: FontWeight.w900,
                        color: Colors.black
                      ),
                      child:AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText("Flash Chat", speed: Duration(milliseconds: 300)),
                        ],
                      ),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            PaddingsButton(onPressed: (){
              Navigator.pushNamed(context, LoginScreen.id);
            },color: Colors.lightBlueAccent, text: 'Log In',),
            PaddingsButton(onPressed: (){
              Navigator.pushNamed(context, RegistrationScreen.id);
            }, text: "Register",color:Colors.lightBlueAccent,),
          ],
        ),
      ),
    );
  }
}


