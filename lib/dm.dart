import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
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

  //var app = new Angel()..lazyParseBodies = true;

  var friendsFile = new File('friends.json');
  List<int> friendIds = [];

  if (await friendsFile.exists()) {
    var list = JSON.decode(await friendsFile.readAsString());
    friendIds.addAll(list);
  }

  Future<List<int>> fetchNewFriends() async {
    int cursor = -1;
    var newFriends = <int>[];

    while (cursor != 0) {
      var response = await createTwitter()
          .request('GET', 'followers/ids.json?cursor=$cursor');
      var friendsList =
          FollowerIdsResponseSerializer.fromMap(JSON.decode(response.body));

      for (var id in friendsList.ids) {
        if (!friendIds.contains(id)) {
          newFriends.add(id);
          friendIds.add(id);
        }
      }

      cursor = friendsList.nextCursor;
      //print(cursor);
      break;
    }

    await friendsFile.writeAsString(JSON.encode(friendIds));
    return newFriends;
  }

  // Get first page
  await fetchNewFriends();
  print('Initial friends: $friendIds');

  new Timer.periodic(new Duration(milliseconds: config.delay ?? 60000),
      (Timer timer) async {
    var newFriends = await fetchNewFriends();
    print('New friends: $newFriends');
    var messageFile = new File('message.txt');
    var messageText = await messageFile.readAsString();

    for (var id in newFriends) {
      var response = await createTwitter().twitterClient.request(
            'POST',
            'https://api.twitter.com/1.1/direct_messages/events/new.json',
            headers: {'content-type': 'application/json'},
            body: JSON.encode({
              "event": {
                "type": "message_create",
                "message_create": {
                  "target": {"recipient_id": id.toString()},
                  "message_data": {
                    "text": messageText,
                  }
                }
              }
            }),
          );

      if (response.statusCode >= 400)
        print('Could not DM user $id: ${response.statusCode} ${response
                .body}');
      else {
        print(response.statusCode);
        print(response.body);
      }
    }
  });
}
