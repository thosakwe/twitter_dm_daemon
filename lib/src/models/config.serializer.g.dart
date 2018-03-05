// GENERATED CODE - DO NOT MODIFY BY HAND

part of dm.src.models.config;

// **************************************************************************
// Generator: SerializerGenerator
// **************************************************************************

abstract class ConfigSerializer {
  static Config fromMap(Map map,
      {List<_TwitterAuthKeys> auth, String publicIp, int delay}) {
    return new Config(
        auth: map['auth'] is Iterable
            ? map['auth'].map(TwitterAuthKeysSerializer.fromMap).toList()
            : null,
        publicIp: map['public_ip'],
        delay: map['delay']);
  }

  static Map<String, dynamic> toMap(Config model) {
    return {
      'auth': model.auth?.map(TwitterAuthKeysSerializer.toMap)?.toList(),
      'public_ip': model.publicIp,
      'delay': model.delay
    };
  }
}

abstract class TwitterAuthKeysSerializer {
  static TwitterAuthKeys fromMap(Map map,
      {String key,
      String secret,
      String accessToken,
      String accessTokenSecret}) {
    return new TwitterAuthKeys(
        key: map['key'],
        secret: map['secret'],
        accessToken: map['access_token'],
        accessTokenSecret: map['access_token_secret']);
  }

  static Map<String, dynamic> toMap(TwitterAuthKeys model) {
    return {
      'key': model.key,
      'secret': model.secret,
      'access_token': model.accessToken,
      'access_token_secret': model.accessTokenSecret
    };
  }
}

abstract class FriendListResponseSerializer {
  static FriendListResponse fromMap(Map map,
      {int previousCursor, int nextCursor, List<_TwitterUser> users}) {
    return new FriendListResponse(
        previousCursor: map['previous_cursor'],
        nextCursor: map['next_cursor'],
        users: map['users'] is Iterable
            ? map['users'].map(TwitterUserSerializer.fromMap).toList()
            : null);
  }

  static Map<String, dynamic> toMap(FriendListResponse model) {
    return {
      'previous_cursor': model.previousCursor,
      'next_cursor': model.nextCursor,
      'users': model.users?.map(TwitterUserSerializer.toMap)?.toList()
    };
  }
}

abstract class TwitterUserSerializer {
  static TwitterUser fromMap(Map map, {String idStr, String screenName}) {
    return new TwitterUser(
        idStr: map['id_str'], screenName: map['screen_name']);
  }

  static Map<String, dynamic> toMap(TwitterUser model) {
    return {'id_str': model.idStr, 'screen_name': model.screenName};
  }
}
