import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyAppHome(),
    );
  }
}

class MyAppHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppHomeState();
  }
}

class _MyAppHomeState extends State<MyAppHome> {
  String username = '';
  String lorem =
      '                                                       Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus gravida vel augue eu aliquet. Proin blandit felis nibh, eget feugiat mauris consectetur quis. Maecenas interdum pulvinar viverra. Donec luctus felis quam, tincidunt bibendum urna vestibulum in. Sed pretium urna in iaculis finibus. Nulla iaculis consectetur nisl, quis egestas velit condimentum vel. Sed sit amet volutpat est. Vestibulum tempor lorem ut egestas vestibulum. Suspendisse consectetur id ante ut commodo. Vestibulum enim ligula, sagittis eleifend dapibus sit amet, fringilla sit amet elit. Duis facilisis nisi sit amet tortor condimentum, a lacinia purus pretium. Aliquam cursus massa sed velit placerat, at congue risus eleifend. Pellentesque feugiat aliquam enim quis accumsan. Maecenas rhoncus eget augue non molestie. Vestibulum eget aliquet lacus. In hac habitasse platea dictumst. Morbi nibh lectus, fermentum sed augue posuere, molestie dapibus justo. Nam dapibus imperdiet felis ut venenatis. Ut vel mi ornare, rhoncus eros ac, ultrices sapien. Quisque sit amet sagittis diam. Cras consequat, ipsum eleifend faucibus euismod, elit ipsum condimentum diam, lacinia vulputate nisl dui a orci. Etiam ultricies fermentum ullamcorper. Sed ut facilisis arcu. Vestibulum aliquet porta ligula. Quisque ultricies, felis ac blandit vehicula, elit metus cursus velit, vitae sollicitudin quam arcu id lectus.Sed tellus velit, malesuada fermentum volutpat vitae, aliquam sit amet est. In euismod ex elementum ligula rhoncus tincidunt. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Nunc vel tempor dolor. Proin ultrices elit justo. Vivamus ac purus mauris. Phasellus et accumsan nisl. Phasellus suscipit elementum urna eget ullamcorper. Nam lorem ligula, feugiat et arcu a, euismod faucibus nunc. Mauris feugiat dolor at venenatis scelerisque. Aenean vitae convallis dolor, nec maximus mi. Sed egestas augue nulla, a finibus velit venenatis sed. Morbi commodo orci lorem, eu venenatis sapien maximus sed. Nullam vestibulum purus nulla, et tincidunt nisi rutrum at. Morbi venenatis ligula urna, a auctor justo iaculis a. Quisque ac gravida ligula, eget lacinia sem. Morbi sed sapien in augue placerat convallis id eu felis. Interdum et malesuada fames ac ante ipsum primis in faucibus. Sed dictum mi sed nunc tincidunt auctor. Nullam in erat orci. Fusce congue rutrum scelerisque. Sed pellentesque vitae mi sed hendrerit. Vestibulum at tristique nisi. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Vivamus laoreet eros eu justo mattis, ac efficitur est efficitur. Fusce elit diam, interdum molestie ex vestibulum, elementum pellentesque leo. Nam in odio imperdiet, eleifend enim eget, iaculis nulla. Duis sed sapien molestie lacus consectetur venenatis. Nullam ante dolor, rutrum in tortor id, iaculis accumsan ante. Maecenas in fermentum sem. Maecenas pellentesque eros tortor, eu auctor eros efficitur quis. Suspendisse potenti. Pellentesque a felis arcu. Vestibulum aliquet efficitur neque, convallis ultrices felis elementum sodales. Nunc iaculis erat commodo est porttitor ullamcorper. Etiam imperdiet arcu et venenatis malesuada. Duis tempor ac justo luctus tincidunt. Sed ut varius arcu, sit amet consectetur erat.'
          .toLowerCase()
          .replaceAll(',', '')
          .replaceAll('.', '');

  int step = 0;
  int score = 0;
  int lastTypedAt = 0;
  int typedCharLength = 0;

  void updateLastTypedAt() {
    this.lastTypedAt = new DateTime.now().millisecondsSinceEpoch;
  }

  void onType(String value) {
    updateLastTypedAt();
    String trimmedValue = lorem.trimLeft();

    setState(() {
      if (trimmedValue.indexOf(value) != 0) {
        step = 2;
      } else {
        typedCharLength = value.length;
      }
    });
    print(value);
  }

  void onUserNameType(String value) {
    setState(() {
      this.username = value;
    });
  }

  void resetGame() {
    setState(() {
      typedCharLength = 0;
      step = 1;
    });
  }

  void onStartClick() {
    setState(() {
      updateLastTypedAt();
      step++;
    });

    var timer = Timer.periodic(new Duration(seconds: 1), (timer) async {
      int now = DateTime.now().millisecondsSinceEpoch;

      setState(() {
        if (step == 1 && now - lastTypedAt > 4000) {
          // GAME OVER
          step++;
        }
      });
      if (step != 1) {
        await http.post(
            Uri.parse('https://typing-test-game.herokuapp.com/users/score'),
            body: {
              'userName': username,
              'score': typedCharLength.toString(),
            });
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var shownWidget;

    if (step == 0) {
      shownWidget = <Widget>[
        Text('Welcome to Game! Are you ready to escape the Corona!?'),
        Container(
          padding: EdgeInsets.all(20),
          child: TextField(
            onChanged: onUserNameType,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Enter your name :',
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 10),
          child: RaisedButton(
            child: Text(' Start '),
            onPressed: username.length == 0 ? null : onStartClick,
          ),
        )
      ];
    } else if (step == 1) {
      shownWidget = <Widget>[
        Text('$score'),
        Container(
            margin: EdgeInsets.only(left: 0),
            height: 40,
            child: Marquee(
              text: lorem,
              style: TextStyle(fontSize: 24, letterSpacing: 2),
              scrollAxis: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.start,
              blankSpace: 20.0,
              velocity: 125,
              // pauseAfterRound: Duration(seconds: 1),
              startPadding: 0,
              accelerationDuration: Duration(seconds: 20),
              accelerationCurve: Curves.ease,
              decelerationDuration: Duration(milliseconds: 500),
              decelerationCurve: Curves.easeOut,
            )),
        Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 32),
            child: TextField(
              // obscureText: true,
              autofocus: true,
              onChanged: onType,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Type',
              ),
            ))
      ];
    } else {
      shownWidget = <Widget>[
        Text('You failed to escape from Corona!! Your Score: $typedCharLength'),
        Container(
            margin: EdgeInsets.only(top: 10),
            child: RaisedButton(
              onPressed: resetGame,
              child: Text('Play again'),
            ))
      ];
    }

    return Scaffold(
      appBar: AppBar(title: Text('Keyboard Speed Calculator')),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: shownWidget,
      )),
    );
  }
}
