import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:minigro/globals/getit.dart';
import 'package:talker/talker.dart';

class DescriptorTile extends StatefulWidget {
  final BluetoothDescriptor descriptor;

  const DescriptorTile({super.key, required this.descriptor});

  @override
  State<DescriptorTile> createState() => _DescriptorTileState();
}

class _DescriptorTileState extends State<DescriptorTile> {
  final Talker talker = getIt();
  List<int> _value = [];

  late StreamSubscription<List<int>> _lastValueSubscription;

  @override
  void initState() {
    super.initState();
    _lastValueSubscription = widget.descriptor.lastValueStream.listen((value) {
      _value = value;
      setState(() {});
    });
  }

  @override
  void dispose() {
    _lastValueSubscription.cancel();
    super.dispose();
  }

  BluetoothDescriptor get d => widget.descriptor;

  List<int> _getRandomBytes() {
    final math = Random();
    return [
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255),
      math.nextInt(255)
    ];
  }

  Future onReadPressed() async {
    try {
      await d.read();
      talker.good("Descriptor Read : Success");
    } catch (e) {
      talker.error("Descriptor Read : Failed", e);
    }
  }

  Future onWritePressed() async {
    try {
      await d.write(_getRandomBytes());
      talker.good("Descriptor Write : Success");
    } catch (e) {
      talker.error("Descriptor Write : Failed", e);
    }
  }

  Widget buildUuid(BuildContext context) {
    String uuid = '0x${widget.descriptor.uuid.str.toUpperCase()}';
    return Text(uuid, style: const TextStyle(fontSize: 13));
  }

  Widget buildValue(BuildContext context) {
    String data = _value.toString();
    return Text(data, style: const TextStyle(fontSize: 13, color: Colors.grey));
  }

  Widget buildReadButton(BuildContext context) {
    return TextButton(
      onPressed: onReadPressed,
      child: const Text("Read"),
    );
  }

  Widget buildWriteButton(BuildContext context) {
    return TextButton(
      onPressed: onWritePressed,
      child: const Text("Write"),
    );
  }

  Widget buildButtonRow(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        buildReadButton(context),
        buildWriteButton(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Descriptor'),
          buildUuid(context),
          buildValue(context),
        ],
      ),
      subtitle: buildButtonRow(context),
    );
  }
}
