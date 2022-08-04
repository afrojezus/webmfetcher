import 'package:animations/animations.dart';
import 'package:contextmenu/contextmenu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get_it/get_it.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webmfetch/sources/4ch.dart';
import 'package:webmfetch/sources/type.dart';
import 'package:webmfetch/thread_view.dart';
import 'package:webmfetch/utils/breakpoint.dart';
import 'package:webmfetch/utils/scrollcontroller.dart';
import 'package:webmfetch/vm/explore_view_model.dart';

class Explore extends StatefulWidget {
  const Explore({Key? key}) : super(key: key);

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  final vm = GetIt.instance<ExploreViewModel>();

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
          title: Text("Explore ${source[vm.webMSource]}"),
          actions: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(children: [
                  IconButton(
                      onPressed: () => vm.refreshCatalog(),
                      icon: const Icon(Icons.refresh),
                      tooltip: "Refresh")
                ])),
          ],
        ),
        body: LayoutBuilder(builder: (context, constraints) {
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

  Widget gridView(BuildContext context, int ratio, double ar) {
    return GridView.builder(
      controller: AdjustableScrollController(80),
      padding: const EdgeInsets.all(8.0),
      itemCount: vm.catalog.length,
      itemBuilder: (context, index) {
        index = index % vm.catalog.length;
        return gridTile(context, vm.catalog[index]);
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: ratio, childAspectRatio: ar),
    );
  }

  Widget gridTile(BuildContext context, Threads threads) {
    return ContextMenuArea(
        builder: (context) => [
              ListTile(
                  onTap: () {
                    launchUrl(Uri.parse("${fourChanURL}thread/${threads.no!}"));
                  },
                  title: Text("Open in browser"))
            ],
        child: OpenContainer(
            openBuilder: (context, action) {
              return ThreadView(thread: threads);
            },
            openColor: Theme.of(context).cardColor,
            closedShape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(9))),
            closedElevation: 0,
            closedColor: Colors.transparent,
            closedBuilder: (context, action) => Card(
                elevation: 1,
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                    onTap: () {
                      action();
                    },
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      AspectRatio(
                          aspectRatio: 2 / 1,
                          child: Image.network(
                              "$fourChanContentURL/${threads.tim!}s.jpg",
                              fit: BoxFit.cover)),
                      Expanded(
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  threads.sub != null
                                      ? HtmlWidget(
                                          threads.sub!,
                                          textStyle: const TextStyle(
                                              fontWeight: FontWeight.w700),
                                        )
                                      : Container(),
                                  threads.com != null
                                      ? HtmlWidget(
                                          threads.com!,
                                          textStyle: const TextStyle(
                                              overflow: TextOverflow.fade),
                                        )
                                      : Container()
                                ],
                              )))
                    ])))));
  }
}
