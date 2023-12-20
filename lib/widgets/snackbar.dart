import 'package:flutter/material.dart';
import 'package:talker_flutter/talker_flutter.dart';

class ExceptionSnackbar extends StatelessWidget {
  const ExceptionSnackbar({
    super.key,
    required this.data,
  });

  final TalkerException data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.red,
        boxShadow: const [
          BoxShadow(
            color: Color(0x19000000),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(2, 4),
          )
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(width: 10),
          const Icon(Icons.warning, color: Colors.white),
          const Spacer(),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Oh no !',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                data.exception.toString(),
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const Spacer(),
          TextButton(
            onPressed: () =>
                ScaffoldMessenger.of(context).hideCurrentSnackBar(),
            child: const Text("Undo"),
          )
        ],
      ),
    );
  }
}
