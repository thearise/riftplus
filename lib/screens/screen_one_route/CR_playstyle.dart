import 'package:flutter/material.dart';

class CR_playstyle extends StatefulWidget {
  const CR_playstyle({Key key}) : super(key: key);
  //final called1 = false;
  @override
  _CR_playstyleState createState() => _CR_playstyleState();
}

class _CR_playstyleState extends State<CR_playstyle> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin<CR_playstyle> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return buttonSection;
  }

  Widget buttonSection = Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          color: Colors.amber,
        )
      ],
    ),
  );
}