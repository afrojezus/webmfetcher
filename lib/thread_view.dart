import 'dart:io';

import 'package:dart_vlc/dart_vlc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:webmfetch/model/library_entity.dart';
import 'package:webmfetch/sources/4ch.dart';
import 'package:webmfetch/utils/breakpoint.dart';
import 'package:webmfetch/utils/scrollcontroller.dart';
import 'package:webmfetch/vm/shared_view_model.dart';

// Currently very specific to 4chans API

class ThreadView extends StatefulWidget {
  const ThreadView({super.key, required this.thread});

  final Threads thread;

  @override
  State<ThreadView> createState() => ThreadViewState();
}

class ThreadViewState extends State<ThreadView> {
  final vm = GetIt.instance<SharedViewModel>();
  bool savingMuch = false;
  double savingMuchProgress = 0;
  bool converting = false;
  bool saving = false;
  bool loading = true;
  List<Posts> posts = <Posts>[];
  Player? player;
  Posts? currentPost;

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<File> convertToMPEG(File file) async {
    try {
      setState(() {
        converting = true;
      });
      var process =
          await Process.run('ffmpeg', ['-i', file.path, "${file.path}.mp4"]);
      if (kDebugMode) {
        print(process.exitCode);
      }
      setState(() {
        converting = false;
      });
      return File("${file.path}.mp4");
    } catch (e) {
      rethrow;
    }
  }

  Future<void> saveToLibrary(BuildContext context, Posts? post) async {
    try {
      setState(() {
        saving = true;
      });
      final dir = await getApplicationDocumentsDirectory();
      currentPost = post;
      final file = File(dir.path +
          Platform.pathSeparator +
          post!.tim.toString() +
          post.ext.toString());
      HttpClient httpClient = HttpClient();
      final req = await httpClient
          .getUrl(Uri.parse("$fourChanContentURL${post.tim}${post.ext}"));
      final res = await req.close();
      if (res.statusCode != 200) throw Exception('Failed to request file');
      final bytes = await consolidateHttpClientResponseBytes(res);
      await file.writeAsBytes(bytes);
      final mp4 = await convertToMPEG(file);
      await file.delete();
      vm.library.add(LibraryEntity(
          id: post.tim!,
          thumb: "$fourChanContentURL${post.tim}s.jpg",
          filepath: mp4.path,
          name: "${post.tim}${post.ext}",
          origin: widget.thread.sub ?? "/wsg/",
          time: DateTime.now()));
      vm.saveState();
    } catch (e) {
      rethrow;
    } finally {
      setState(() {
        saving = false;
      });
    }
  }

  Future<void> saveAllToLibrary(BuildContext context) async {
    player?.stop();
    setState(() {
      savingMuch = true;
      savingMuchProgress = 0;
    });
    var allWebms = posts.where((element) => element.ext != null);
    for (var element in allWebms) {
      // 4chan API: Do not make more than one request per second.
      await Future.delayed(const Duration(seconds: 1), () async {
        await saveToLibrary(context, element);
        setState(() {
          savingMuchProgress++;
        });
      });
    }
    setState(() {
      savingMuch = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: widget.thread.sub != null
              ? Text(widget.thread.sub!)
              : HtmlWidget(widget.thread.com!),
          actions: [
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(children: [
                  Center(
                      child: Text(
                          "${posts.length} posts / ${posts.where((element) => element.ext != null).length} webms")),
                  IconButton(
                      onPressed: !saving || !savingMuch
                          ? () => saveAllToLibrary(context)
                          : null,
                      icon: const Icon(Icons.download),
                      tooltip: "Save all to library")
                ]))
          ],
        ),
        body: savingMuch
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                    Center(
                        child: Column(
                      children: [
                        currentPost != null
                            ? SizedBox(
                                height: currentPost!.tnH!.floorToDouble(),
                                width: currentPost!.tnW!.floorToDouble(),
                                child: Image.network(
                                    "$fourChanContentURL/${currentPost!.tim!}s.jpg",
                                    fit: BoxFit.cover))
                            : Container(),
                        Text(
                            "Currently saving ${savingMuchProgress + 1} webms out of ${posts.where((element) => element.ext != null).length}..."),
                        LinearProgressIndicator(
                            value: (savingMuchProgress /
                                    posts
                                        .where((element) => element.ext != null)
                                        .length)
                                .toDouble())
                      ],
                    ))
                  ])
            : Stack(children: [
                LayoutBuilder(builder: (context, constraints) {
                  if (constraints.maxWidth > kTabletBreakpoint) {
                    return Row(
                      children: [
                        Flexible(
                            child: ListView.builder(
                                controller: AdjustableScrollController(80),
                                scrollDirection: Axis.vertical,
                                itemCount: posts.length,
                                itemBuilder: (context, index) {
                                  return listTile(posts[index], index);
                                })),
                        if (currentPost != null)
                          Expanded(
                              child: Column(children: [
                            Expanded(
                                child: Video(
                                    player: player,
                                    progressBarThumbColor:
                                        Theme.of(context).primaryColor,
                                    progressBarActiveColor:
                                        Theme.of(context).primaryColor,
                                    showControls: true)),
                            Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).backgroundColor),
                                child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(children: [
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                "${currentPost!.tim}${currentPost!.ext}",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge)
                                          ]),
                                      Expanded(child: Container()),
                                      ElevatedButton(
                                          onPressed: saving ||
                                                  vm.library
                                                      .where((x) =>
                                                          x.id ==
                                                          currentPost!.tim!)
                                                      .isNotEmpty
                                              ? null
                                              : () => saveToLibrary(
                                                  context, currentPost),
                                          child: Row(children: [
                                            converting
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 16.0),
                                                    child: Center(
                                                        child: SizedBox(
                                                            width: 16,
                                                            height: 16,
                                                            child:
                                                                CircularProgressIndicator(
                                                              color: Theme.of(
                                                                      context)
                                                                  .hintColor,
                                                            ))))
                                                : Container(),
                                            Text(vm.library
                                                    .where((x) =>
                                                        x.id ==
                                                        currentPost!.tim!)
                                                    .isNotEmpty
                                                ? "Saved"
                                                : "Save to library")
                                          ]))
                                    ])))
                          ]))
                        else
                          Container()
                      ],
                    );
                  } else {
                    return Column(children: [
                      if (currentPost != null)
                        Expanded(
                            child: Card(
                                clipBehavior: Clip.antiAlias,
                                child: Column(children: [
                                  Expanded(
                                      child: Video(
                                          player: player,
                                          progressBarThumbColor:
                                              Theme.of(context).primaryColor,
                                          progressBarActiveColor:
                                              Theme.of(context).primaryColor,
                                          showControls: true)),
                                  Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(children: [
                                        Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  "${currentPost!.tim}${currentPost!.ext}",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge)
                                            ]),
                                        Expanded(child: Container()),
                                        ElevatedButton(
                                            onPressed: saving ||
                                                    vm.library
                                                        .where((x) =>
                                                            x.id ==
                                                            currentPost!.tim!)
                                                        .isNotEmpty
                                                ? null
                                                : () => saveToLibrary(
                                                    context, currentPost),
                                            child: Row(children: [
                                              converting
                                                  ? Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 16.0),
                                                      child: Center(
                                                          child: SizedBox(
                                                              width: 16,
                                                              height: 16,
                                                              child:
                                                                  CircularProgressIndicator(
                                                                color: Theme.of(
                                                                        context)
                                                                    .hintColor,
                                                              ))))
                                                  : Container(),
                                              Text(vm.library
                                                      .where((x) =>
                                                          x.id ==
                                                          currentPost!.tim!)
                                                      .isNotEmpty
                                                  ? "Saved"
                                                  : "Save to library")
                                            ]))
                                      ]))
                                ])))
                      else
                        Container(),
                      Flexible(
                          child: ListView.builder(
                              controller: AdjustableScrollController(80),
                              scrollDirection: Axis.vertical,
                              itemCount: posts.length,
                              itemBuilder: (context, index) {
                                return listTile(posts[index], index);
                              })),
                    ]);
                  }
                }),
                Center(
                  child:
                      loading ? const CircularProgressIndicator() : Container(),
                )
              ]));
  }

  Widget listTile(Posts post, int index) {
    return InkWell(
        enableFeedback: post.ext != null,
        onTap: () {
          if (post.ext != null) {
            player?.open(
              Media.network("$fourChanContentURL${post.tim!}${post.ext}"),
              autoStart: true,
            );
            setState(() {
              currentPost = post;
            });
          }
        },
        child: ListTile(
          visualDensity: index == 0
              ? const VisualDensity(vertical: 4)
              : const VisualDensity(horizontal: 0, vertical: 0),
          title: Text(post.name!),
          subtitle: post.com != null ? HtmlWidget(post.com!) : Container(),
          leading: post.ext != null
              ? SizedBox(
                  height: index == 0 ? 100 : post.tnH!.floorToDouble(),
                  width: index == 0 ? 200 : 100,
                  child: Image.network("$fourChanContentURL/${post.tim!}s.jpg",
                      fit: BoxFit.cover))
              : null,
        ));
  }

  void fetchPosts() async {
    Thread thread = await FourChanAPI().fetchPosts(widget.thread.no!);
    List<Posts> _posts = <Posts>[];
    if (thread.posts != null) {
      for (var post in thread.posts!) {
        _posts.add(post);
      }
      setState(() {
        posts = _posts;
        loading = false;
        currentPost = _posts[0];
      });
      player = Player(id: 0);
      player?.setVolume(0.5);
      player?.open(
          Media.network("$fourChanContentURL${posts[0].tim!}${posts[0].ext}"),
          autoStart: true);
    }
  }

  @override
  void dispose() {
    player?.stop();
    player?.dispose();
    super.dispose();
  }
}
