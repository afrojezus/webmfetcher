import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stacked/stacked.dart';
import 'package:webmfetch/vm/shared_view_model.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final vm = GetIt.instance<SharedViewModel>();

  @override
  void initState() {
    vm.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder.reactive(
        disposeViewModel: false,
        viewModelBuilder: () => vm,
        builder: (context, model, child) => rootScreen(context));
  }

  Widget rootScreen(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: Column(children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: const Text(
                "The option to change sources in the explore screen will come here later"),
          )
        ]));
  }
}
