import 'package:contextmenu/contextmenu.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stacked/stacked.dart';
import 'package:webmfetch/model/library_entity.dart';
import 'package:webmfetch/utils/breakpoint.dart';
import 'package:webmfetch/utils/scrollcontroller.dart';
import 'package:webmfetch/vm/shared_view_model.dart';

class Library extends StatefulWidget {
  const Library({Key? key}) : super(key: key);

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
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

  Future<void> _showHelpDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('How to use webmfetcher'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text(
                    'Webmfetcher obtains webms online and saves them to your device'),
                Text(
                    'It is intentionally built in mind for video editors, which means that the webms get converted to MP4 format'),
                Text(
                    'On mobile phones the webms remain in the same codec due to restrictions'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget rootScreen(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Library"),
          actions: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(children: [
                  const Center(child: Text("List view")),
                  Switch(
                      value: vm.showAsList,
                      onChanged: (bool n) => vm.setListView(n)),
                  IconButton(
                    icon: Icon(Icons.info),
                    tooltip: "Help",
                    onPressed: () => _showHelpDialog(),
                  ),
                  IconButton(
                    onPressed: () {
                      vm.loadState();
                    },
                    icon: const Icon(Icons.refresh),
                    tooltip: "Refresh grid",
                  ),
                  IconButton(
                    onPressed: () {
                      vm.deleteState();
                    },
                    icon: const Icon(Icons.delete),
                    tooltip: "Delete all files",
                  ),
                ])),
          ],
        ),
        body: vm.library.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                      child: Column(
                    children: [
                      Text(
                        "O.O'",
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      Text(
                          "The library is empty! Save some webms to fill it up",
                          style: Theme.of(context).textTheme.titleMedium)
                    ],
                  ))
                ],
              )
            : vm.showAsList
                ? ListView.separated(
                    controller: AdjustableScrollController(80),
                    scrollDirection: Axis.vertical,
                    itemCount: vm.library.length,
                    itemBuilder: (context, index) {
                      return listTile(vm.library[index]);
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider();
                    },
                  )
                : LayoutBuilder(builder: (context, constraints) {
                    if (constraints.maxWidth <= kMobileBreakpoint) {
                      return gridView(context, 1, 1.3);
                    } else if (constraints.maxWidth > kMobileBreakpoint &&
                        constraints.maxWidth <= kTabletBreakpoint) {
                      return gridView(context, 2, 1.2);
                    } else if (constraints.maxWidth > kTabletBreakpoint &&
                        constraints.maxWidth <= kDesktopBreakPoint) {
                      return gridView(context, 3, 1.1);
                    } else {
                      return gridView(context, 8, 0.7);
                    }
                  }));
  }

  Widget listTile(LibraryEntity entity) {
    return ContextMenuArea(
        builder: (context) => [
              ListTile(
                  onTap: () async {
                    final dir = await getApplicationDocumentsDirectory();
                    OpenFile.open("${dir.path}\\");
                  },
                  title: const Text("Open path"))
            ],
        child: InkWell(
            onTap: () {
              OpenFile.open(entity.filepath);
            },
            child: ListTile(
              title: Text(entity.name),
              subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(entity.origin),
                    Text(entity.time.toIso8601String())
                  ]),
              leading: SizedBox(
                  height: 100,
                  width: 100,
                  child: Image.network(entity.thumb, fit: BoxFit.cover)),
            )));
  }

  Widget gridView(BuildContext context, int ratio, double ar) {
    return GridView.builder(
      scrollDirection: Axis.vertical,
      itemCount: vm.library.length,
      padding: const EdgeInsets.all(10.0),
      itemBuilder: (context, index) {
        index = index % vm.library.length;
        return gridTile(vm.library[index]);
      },
      controller: AdjustableScrollController(80),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: ratio, childAspectRatio: ar),
    );
  }

  Widget gridTile(LibraryEntity entity) {
    return ContextMenuArea(
        builder: (context) => [
              ListTile(
                  onTap: () async {
                    final dir = await getApplicationDocumentsDirectory();
                    OpenFile.open("${dir.path}\\");
                  },
                  title: Text("Open path"))
            ],
        child: SizedBox(
            height: 300,
            child: Card(
                elevation: 1,
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                    onTap: () {
                      OpenFile.open(entity.filepath);
                    },
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      AspectRatio(
                          aspectRatio: 2 / 1,
                          child:
                              Image.network(entity.thumb, fit: BoxFit.cover)),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entity.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700),
                              ),
                              Text(entity.origin),
                              Text(entity.time.toIso8601String())
                            ],
                          ))
                    ])))));
  }
}
