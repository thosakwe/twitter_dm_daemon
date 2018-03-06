import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:io' as io show pid;
import 'dart:math';
import 'package:millisecond/millisecond.dart' as ms;
import 'package:stack_trace/stack_trace.dart';
import 'package:twitter/twitter.dart';
import 'package:yaml/yaml.dart' as yaml;
import 'src/models/config.dart';

final Directory parentDir = new File.fromUri(Platform.script).parent.parent;

main() {
  var logFile = new File.fromUri(parentDir.uri.resolve('error_log.txt'));

  runZoned(daemon, onError: (e, st) {
    var sink = logFile.openWrite(mode: FileMode.APPEND);
    sink
      ..writeln(e)
      ..writeln(new Chain.forTrace(st).terse)
      ..close();
  });
}

daemon() async {
  var pidFile = new File.fromUri(parentDir.uri.resolve('run.pid'));

  // Kill existing process
  if (await pidFile.exists()) {
    var pid = await pidFile.readAsString().then(int.parse);
    Process.killPid(pid);
    await pidFile.writeAsString(io.pid.toString());
  }

  var configFile = new File.fromUri(parentDir.uri.resolve('twitter.yaml'));
  var config = ConfigSerializer.fromMap(
      yaml.loadYamlDocument(await configFile.readAsString()).contents.value);
  var delay = new Duration(milliseconds: config.delay);
  print('Polling delay: ${ms.format(delay.inMilliseconds, long: true)}');
  var rnd = new Random();

  Twitter createTwitter() {
    var keys = config.auth[rnd.nextInt(config.auth.length)];
    return new Twitter(
        keys.key, keys.secret, keys.accessToken, keys.accessTokenSecret);
  }

  //var app = new Angel()..lazyParseBodies = true;

  var friendsFile = new File.fromUri(parentDir.uri.resolve('friends.json'));
  print('friends.json: ${friendsFile.absolute.path} (exists: ${await friendsFile
      .exists()})');
  List<int> friendIds = [];

  bool shouldFetch = true;

  if (await friendsFile.exists()) {
    shouldFetch = false;
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
  if (shouldFetch) {
    print('No friends.json found... Fetching current follower list');
    await fetchNewFriends();
  }

  print('${friendIds.length} initial friends');

  checkForNewFriends(Timer timer) async {
    var newFriends = await fetchNewFriends();
    if (newFriends.isEmpty) return;
    print('New friends: $newFriends');
    var messageFile = new File.fromUri(parentDir.uri.resolve('message.txt'));
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
        //print(response.statusCode);
        //print(response.body);
      }
    }

    print('${friendIds.length} current friends');
  }

  await checkForNewFriends(null);

  new Timer.periodic(
      new Duration(milliseconds: config.delay), checkForNewFriends);
}
