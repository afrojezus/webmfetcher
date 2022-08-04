import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Thread {
  List<Posts>? posts;

  Thread({this.posts});

  Thread.fromJson(Map<String, dynamic> json) {
    if (json['posts'] != null) {
      posts = <Posts>[];
      json['posts'].forEach((v) {
        posts!.add(Posts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (posts != null) {
      data['posts'] = posts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Posts {
  int? no;
  String? now;
  String? name;
  String? sub;
  String? filename;
  String? ext;
  int? w;
  int? h;
  int? tnW;
  int? tnH;
  int? tim;
  int? time;
  String? md5;
  int? fsize;
  int? resto;
  int? bumplimit;
  int? imagelimit;
  String? semanticUrl;
  int? replies;
  int? images;
  int? uniqueIps;
  String? com;

  Posts(
      {this.no,
      this.now,
      this.name,
      this.sub,
      this.filename,
      this.ext,
      this.w,
      this.h,
      this.tnW,
      this.tnH,
      this.tim,
      this.time,
      this.md5,
      this.fsize,
      this.resto,
      this.bumplimit,
      this.imagelimit,
      this.semanticUrl,
      this.replies,
      this.images,
      this.uniqueIps,
      this.com});

  Posts.fromJson(Map<String, dynamic> json) {
    no = json['no'];
    now = json['now'];
    name = json['name'];
    sub = json['sub'];
    filename = json['filename'];
    ext = json['ext'];
    w = json['w'];
    h = json['h'];
    tnW = json['tn_w'];
    tnH = json['tn_h'];
    tim = json['tim'];
    time = json['time'];
    md5 = json['md5'];
    fsize = json['fsize'];
    resto = json['resto'];
    bumplimit = json['bumplimit'];
    imagelimit = json['imagelimit'];
    semanticUrl = json['semantic_url'];
    replies = json['replies'];
    images = json['images'];
    uniqueIps = json['unique_ips'];
    com = json['com'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['no'] = no;
    data['now'] = now;
    data['name'] = name;
    data['sub'] = sub;
    data['filename'] = filename;
    data['ext'] = ext;
    data['w'] = w;
    data['h'] = h;
    data['tn_w'] = tnW;
    data['tn_h'] = tnH;
    data['tim'] = tim;
    data['time'] = time;
    data['md5'] = md5;
    data['fsize'] = fsize;
    data['resto'] = resto;
    data['bumplimit'] = bumplimit;
    data['imagelimit'] = imagelimit;
    data['semantic_url'] = semanticUrl;
    data['replies'] = replies;
    data['images'] = images;
    data['unique_ips'] = uniqueIps;
    data['com'] = com;
    return data;
  }
}

class Catalog {
  int? page;
  List<Threads>? threads;

  Catalog({this.page, this.threads});

  Catalog.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    if (json['threads'] != null) {
      threads = <Threads>[];
      json['threads'].forEach((v) {
        threads!.add(Threads.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['page'] = page;
    if (threads != null) {
      data['threads'] = threads!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Threads {
  int? no;
  int? sticky;
  int? closed;
  String? now;
  String? name;
  String? sub;
  String? com;
  int? time;
  int? resto;
  String? capcode;
  String? semanticUrl;
  int? replies;
  int? images;
  int? omittedPosts;
  int? omittedImages;
  List<LastReplies>? lastReplies;
  int? lastModified;
  String? filename;
  String? ext;
  int? w;
  int? h;
  int? tnW;
  int? tnH;
  int? tim;
  String? md5;
  int? fsize;
  int? bumplimit;
  int? imagelimit;

  Threads(
      {this.no,
      this.sticky,
      this.closed,
      this.now,
      this.name,
      this.sub,
      this.com,
      this.time,
      this.resto,
      this.capcode,
      this.semanticUrl,
      this.replies,
      this.images,
      this.omittedPosts,
      this.omittedImages,
      this.lastReplies,
      this.lastModified,
      this.filename,
      this.ext,
      this.w,
      this.h,
      this.tnW,
      this.tnH,
      this.tim,
      this.md5,
      this.fsize,
      this.bumplimit,
      this.imagelimit});

  Threads.fromJson(Map<String, dynamic> json) {
    no = json['no'];
    sticky = json['sticky'];
    closed = json['closed'];
    now = json['now'];
    name = json['name'];
    sub = json['sub'];
    com = json['com'];
    time = json['time'];
    resto = json['resto'];
    capcode = json['capcode'];
    semanticUrl = json['semantic_url'];
    replies = json['replies'];
    images = json['images'];
    omittedPosts = json['omitted_posts'];
    omittedImages = json['omitted_images'];
    if (json['last_replies'] != null) {
      lastReplies = <LastReplies>[];
      json['last_replies'].forEach((v) {
        lastReplies!.add(LastReplies.fromJson(v));
      });
    }
    lastModified = json['last_modified'];
    filename = json['filename'];
    ext = json['ext'];
    w = json['w'];
    h = json['h'];
    tnW = json['tn_w'];
    tnH = json['tn_h'];
    tim = json['tim'];
    md5 = json['md5'];
    fsize = json['fsize'];
    bumplimit = json['bumplimit'];
    imagelimit = json['imagelimit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['no'] = no;
    data['sticky'] = sticky;
    data['closed'] = closed;
    data['now'] = now;
    data['name'] = name;
    data['sub'] = sub;
    data['com'] = com;
    data['time'] = time;
    data['resto'] = resto;
    data['capcode'] = capcode;
    data['semantic_url'] = semanticUrl;
    data['replies'] = replies;
    data['images'] = images;
    data['omitted_posts'] = omittedPosts;
    data['omitted_images'] = omittedImages;
    if (lastReplies != null) {
      data['last_replies'] = lastReplies!.map((v) => v.toJson()).toList();
    }
    data['last_modified'] = lastModified;
    data['filename'] = filename;
    data['ext'] = ext;
    data['w'] = w;
    data['h'] = h;
    data['tn_w'] = tnW;
    data['tn_h'] = tnH;
    data['tim'] = tim;
    data['md5'] = md5;
    data['fsize'] = fsize;
    data['bumplimit'] = bumplimit;
    data['imagelimit'] = imagelimit;
    return data;
  }
}

class LastReplies {
  int? no;
  String? now;
  String? name;
  String? com;
  int? time;
  int? resto;
  String? capcode;
  String? filename;
  String? ext;
  int? w;
  int? h;
  int? tnW;
  int? tnH;
  int? tim;
  String? md5;
  int? fsize;

  LastReplies(
      {this.no,
      this.now,
      this.name,
      this.com,
      this.time,
      this.resto,
      this.capcode,
      this.filename,
      this.ext,
      this.w,
      this.h,
      this.tnW,
      this.tnH,
      this.tim,
      this.md5,
      this.fsize});

  LastReplies.fromJson(Map<String, dynamic> json) {
    no = json['no'];
    now = json['now'];
    name = json['name'];
    com = json['com'];
    time = json['time'];
    resto = json['resto'];
    capcode = json['capcode'];
    filename = json['filename'];
    ext = json['ext'];
    w = json['w'];
    h = json['h'];
    tnW = json['tn_w'];
    tnH = json['tn_h'];
    tim = json['tim'];
    md5 = json['md5'];
    fsize = json['fsize'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['no'] = no;
    data['now'] = now;
    data['name'] = name;
    data['com'] = com;
    data['time'] = time;
    data['resto'] = resto;
    data['capcode'] = capcode;
    data['filename'] = filename;
    data['ext'] = ext;
    data['w'] = w;
    data['h'] = h;
    data['tn_w'] = tnW;
    data['tn_h'] = tnH;
    data['tim'] = tim;
    data['md5'] = md5;
    data['fsize'] = fsize;
    return data;
  }
}

const fourChanURL = "https://boards.4channel.org/wsg/";
const fourChanContentURL = "https://i.4cdn.org/wsg/";

class FourChanAPI {
  List<Threads> catalog = <Threads>[];

  Future<void> fetchCatalog() async {
    catalog.clear();
    try {
      final response =
          await http.get(Uri.parse('https://a.4cdn.org/wsg/catalog.json'));

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
      }
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        for (var element in data.skip(1)) {
          // Skip the sticky
          var catalog = Catalog.fromJson(element);
          catalog.threads?.forEach((thread) {
            this.catalog.add(thread);
          });
        }
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<Thread> fetchPosts(int no) async {
    try {
      final response =
          await http.get(Uri.parse('https://a.4cdn.org/wsg/thread/$no.json'));

      if (kDebugMode) {
        print('Response status: ${response.statusCode}');
      }
      if (response.statusCode == 200) {
        final dynamic data = json.decode(response.body);
        return Thread.fromJson(data);
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      rethrow;
    }
  }
}
