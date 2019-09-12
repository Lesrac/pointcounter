import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:pointcounter/player.dart';
import 'package:screen/screen.dart';

import 'textfield_focus.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Points in the game'),
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
    Screen.keepOn(true);
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
      rows.add(Row(
        children: <Widget>[
          Text(
            _countPoints(player),
            style: Theme.of(context).textTheme.subhead,
          )
        ],
      ));
      _playerRows[player] = rows.toList();
      columns.add(Column(
        children: _playerRows[player], //[listViewBuild(player)],
      ));
    }
    return columns;
  }

  String _countPoints(Player player) {
    var sum = 0;
    player.points.forEach((point) => sum += point);
    return sum.toString();
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
    for (; index < player.points.length; index++) {
      rows.add(Row(
        children: <Widget>[
          _createBaseContainer(player, index),
        ],
      ));
    }
    rows.add(Row(
      children: <Widget>[
        _createBaseContainer(player, index++),
      ],
    ));
    return rows;
  }

  Widget _createBaseContainer(Player player, int index) {
    return TextfieldFocus(
        player: player,
        players: _players.length,
        index: index,
        func: _setState);
  }

  int getMaxPlayerColumns() {
    int maxColumns = 0;
    _players.forEach((player) {
      if (player.points.length - 1 > maxColumns) {
        maxColumns = player.points.length - 1;
      }
    });
    return maxColumns;
  }

  void _setState() {
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
