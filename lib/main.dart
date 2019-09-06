import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:pointcounter/player.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Player> _players = [];
  List<TextEditingController> _controllers = [];
  LinkedHashMap _playerRows = new LinkedHashMap<Player, List<Row>>();

  @override
  void initState() {
    super.initState();
    _initPlayers();
  }

  void _initPlayers() {
    _players.add(Player(
      name: 'Player 1',
      points: [],
    ));
    _players.add(Player(
      name: 'Player 2',
      points: [],
    ));
  }

  List<Column> buildHeadingColumns() {
    List<Column> columns = [];
    for (var player in _players) {
      var rows = List<Row>();
      rows.add(Row(
        children: <Widget>[
          Text(
            player.name,
            style: Theme.of(context).textTheme.headline,
          ),
        ],
      ));
      rows.addAll(buildRows(player));
      _playerRows[player] = rows.toList();
      columns.add(Column(
        children: _playerRows[player], //[listViewBuild(player)],
      ));
    }
    return columns;
  }

  Widget listViewBuild(Player player) {
    return ListView.builder(
      itemBuilder: (context, index) {
        TextEditingController controller = new TextEditingController();
        _controllers.add(controller);
        return _buildRow(player.points[index], controller);
      },
    );
  }

  Widget _buildRow(int pair, TextEditingController controller) {
    return ListTile(
      title: TextField(
        controller: controller,
      ),
    );
  }

  List<Row> buildRows(Player player) {
    List<Row> rows = [];
    int index = 0;
    for(; index < player.points.length; index++) {
      rows.add(Row(
        children: <Widget>[
          Container(
              padding: EdgeInsets.all(2.0),
              width: MediaQuery.of(context).size.width / _players.length,
              child: TextField(
                keyboardType: TextInputType.number,
                controller: _createController(player, index),
              )),
        ],
      ));
    }
    rows.add(Row(
      children: <Widget>[
        Container(
            padding: EdgeInsets.all(2.0),
            width: MediaQuery.of(context).size.width / _players.length,
            child: TextField(
              controller: _createController(player, index++),
              keyboardType: TextInputType.number,
            )),
      ],
    ));
    return rows;
  }

  TextEditingController _createController(Player player, int index) {
    TextEditingController textEditingController = new TextEditingController();
    if (player.points.length > index && player.points[index] != null) {
      textEditingController.text = player.points[index].toString();
    }
    textEditingController.addListener(() {
      if (textEditingController.text.trim() != '') {
        int newValue = int.parse(textEditingController.text);
        if (player.points.length <= index) {
          player.points.add(newValue);
          _addColumnForPlayer(player);
        } else {
          player.points[index] = newValue;
        }
      }
    });
    return textEditingController;
  }

  void _addColumnForPlayer(Player player) {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Row(
              children: buildHeadingColumns(),
            ),
          ),
        ));
  }
}
