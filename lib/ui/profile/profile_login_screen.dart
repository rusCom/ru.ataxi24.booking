import 'package:booking/models/main_application.dart';
import 'package:booking/models/profile.dart';
import 'package:booking/ui/profile/profile_registration_screen.dart';
import 'package:booking/ui/utils/gradient_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:page_transition/page_transition.dart';


class ProfileLoginScreen extends StatefulWidget {
  final Widget background;

  ProfileLoginScreen({this.background});

  @override
  _ProfileLoginScreenState createState() => _ProfileLoginScreenState();
}

class _ProfileLoginScreenState extends State<ProfileLoginScreen> with SingleTickerProviderStateMixin {  
  String errorText = "Номер телефона";
  Color errorColor = Color(0xFF999A9A);
  final MaskedTextController controller = MaskedTextController(mask: '(000) 000-00-00');


  @override
  void initState() {
    super.initState();
    controller.text = Profile().phone;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          widget.background,
          Positioned(
            bottom: MediaQuery.of(context).size.height - MediaQuery.of(context).size.height / 3,
            left: MediaQuery.of(context).size.width / 2.5,
            child: Image.asset(
              "assets/images/splash_logo.png",
              width: MediaQuery.of(context).size.width / 2,
            ),
          ),
          Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 2.3),
              ),
              Column(
                children: <Widget>[
                  ///holds email header and inputField
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 40, bottom: 10),
                        child: Text(
                          errorText,
                          style: TextStyle(fontSize: 16, color: errorColor),
                        ),
                      ),
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(right: 40, bottom: 30),
                            child: Container(
                              width: MediaQuery.of(context).size.width - 40,
                              child: Material(
                                elevation: 10,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(bottomRight: Radius.circular(30), topRight: Radius.circular(0))),
                                child: Padding(
                                  padding: EdgeInsets.only(left: 40, right: 20, top: 10, bottom: 10),
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    controller: controller,
                                    onChanged: (value) => Profile().phone = value,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(
                                          color: Color(0xFFE1E1E1),
                                          fontSize: 14,
                                        )),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(right: 50),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 40),
                                      child: Text(
                                        'Введите Ваш номер телефона...',
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          color: Color(0xFFA0A0A0),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: ShapeDecoration(
                                      shape: CircleBorder(),
                                      gradient: LinearGradient(colors: signInGradients, begin: Alignment.topLeft, end: Alignment.bottomRight),
                                    ),
                                    child: InkWell(
                                      onTap: () => FocusScope.of(context).unfocus(),
                                      child: Icon(
                                        Icons.smartphone,
                                        size: 40,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _termsText(),
                  Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width / 1.7,
                    child: GradientButton(
                      text: "Получить код",
                      onPressed: _onLoginPressed,
                      gradient: signUpGradients,
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
  
  

  Future<void> _onLoginPressed() async {
    MainApplication().showProgress(context);
    String res = await Profile().login();
    MainApplication().hideProgress(context);
    if (res == 'OK'){
      setState(() {
        errorText = "Номер телефона";
        errorColor = Color(0xFF999A9A);
      });
      Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.fade, child: ProfileRegistrationScreen(background: widget.background),duration: Duration(seconds: 2)));
    }
    else {
      setState(() {
        errorText = res;
        errorColor = Colors.deepOrange;
      });
    }
  }
}

Widget _termsText() {
  TextStyle defaultStyle = TextStyle(color: Colors.grey);
  TextStyle linkStyle = TextStyle(color: Colors.blue);
  return Padding(
    padding: const EdgeInsets.all(18.0),
    child: RichText(
      textAlign: TextAlign.left,
      text: TextSpan(style: defaultStyle, children: <TextSpan>[
        TextSpan(text: 'Нажимая кнопку "Получиь код", я соглашаюсь с '),
        TextSpan(
            text: '"Лицензионым соглашением"',
            style: linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                MainApplication().launchURL("https://taxi-econom.ru/clients.php");
              }),
        TextSpan(text: ', '),
        TextSpan(
            text: '"Пользовательским соглашением"',
            style: linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                MainApplication().launchURL("https://taxi-econom.ru/clients.php");
              }),
        TextSpan(text: ', а так же с обработкой моей персональной информации на условиях '),
        TextSpan(
            text: '"Политики конфиденциальности"',
            style: linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                MainApplication().launchURL("https://taxi-econom.ru/clients.php");
              }),
      ]),
    ),
  );
}

const List<Color> signInGradients = [
  Color(0xFF0EDED2),
  Color(0xFF03A0FE),
];

const List<Color> signUpGradients = [
  Color(0xFFFF9945),
  Color(0xFFFc6076),
];
