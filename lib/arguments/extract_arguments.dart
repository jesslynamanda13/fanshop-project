import 'package:fanshop/arguments/user_argument.dart';
import 'package:flutter/material.dart';

class ExtractArgumentsScreen extends StatelessWidget {
  const ExtractArgumentsScreen({super.key});
  static const routeName = '/extractArguments';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as UserArgument;

    return Scaffold(
      appBar: AppBar(
        title: Text('User ID: ${args.uid}'),
      ),
      body: Center(
        child: Text('Username: ${args.username}'),
      ),
    );
  }
}
