import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:angel_framework/angel_framework.dart';
import 'package:twitter/twitter.dart';
import 'package:yaml/yaml.dart' as yaml;
import 'src/models/config.dart';

main(List<String> args) async {
  var configFile = new File('twitter.yaml');
  var config = ConfigSerializer.fromMap(
      yaml.loadYamlDocument(await configFile.readAsString()).contents.value);
  var rnd = new Random();

  Twitter createTwitter() {
    var keys = config.auth[rnd.nextInt(config.auth.length)];
    return new Twitter(
        keys.key, keys.secret, keys.accessToken, keys.accessTokenSecret);
  }

  var app = new Angel()..lazyParseBodies = true;

  List<String> friendIds = [];

  Future<List<TwitterUser>> fetchNewFriends() async {
    int cursor = -1;
    var newFriends = <TwitterUser>[];

    while (cursor != 0) {
      var response = await createTwitter()
          .request('GET', 'friends/list.json?cursor=$cursor');
      var friendsList =
          FriendListResponseSerializer.fromMap(JSON.decode(response.body));

      for (var friend in friendsList.users) {
        if (!friendIds.contains(friend.idStr)) {
          newFriends.add(friend);
          friendIds.add(friend.idStr);
        }
      }

      cursor = friendsList.nextCursor;
      //print(cursor);
      break;
    }

    return newFriends;
  }

  // Get first page
  await fetchNewFriends();

  print(friendIds);

  new Timer.periodic(new Duration(milliseconds: config.delay ?? 60000),
      (Timer timer) async {
    timer.cancel();
    var newFriends = await fetchNewFriends();
    newFriends.forEach((f) => print(f.toJson()));
    print(friendIds);
  });
}
