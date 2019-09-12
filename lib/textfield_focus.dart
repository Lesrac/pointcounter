import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'player.dart';

class TextfieldFocus extends StatefulWidget {
  TextfieldFocus(
      {Key key,
      @required this.player,
      @required this.players,
      @required this.index,
      @required this.func})
      : assert(player != null),
        assert(players != null),
        assert(index != null),
        assert(func != null),
        super(key: key);

  final Player player;
  final int players;
  final int index;
  final Function func;

  @override
  State<StatefulWidget> createState() => _TextfieldFocusState();
}

class _TextfieldFocusState extends State<TextfieldFocus> {
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = new FocusNode();
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        widget.func();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(2.0),
        width: MediaQuery.of(context).size.width / widget.players,
        child: TextField(
          controller: _createController(widget.player, widget.index),
          keyboardType: TextInputType.number,
          focusNode: _focusNode,
        ));
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
        } else {
          player.points[index] = newValue;
        }
      }
    });
    return textEditingController;
  }
}
