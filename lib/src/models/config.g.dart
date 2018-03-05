// GENERATED CODE - DO NOT MODIFY BY HAND

part of dm.src.models.config;

// **************************************************************************
// Generator: JsonModelGenerator
// **************************************************************************

class Config extends _Config {
  Config({this.auth, this.publicIp, this.delay});

  @override
  final List<_TwitterAuthKeys> auth;

  @override
  final String publicIp;

  @override
  final int delay;

  Config copyWith({List<_TwitterAuthKeys> auth, String publicIp, int delay}) {
    return new Config(
        auth: auth ?? this.auth,
        publicIp: publicIp ?? this.publicIp,
        delay: delay ?? this.delay);
  }

  Map<String, dynamic> toJson() {
    return ConfigSerializer.toMap(this);
  }
}

class TwitterAuthKeys extends _TwitterAuthKeys {
  TwitterAuthKeys(
      {this.key, this.secret, this.accessToken, this.accessTokenSecret});

  @override
  final String key;

  @override
  final String secret;

  @override
  final String accessToken;

  @override
  final String accessTokenSecret;

  TwitterAuthKeys copyWith(
      {String key,
      String secret,
      String accessToken,
      String accessTokenSecret}) {
    return new TwitterAuthKeys(
        key: key ?? this.key,
        secret: secret ?? this.secret,
        accessToken: accessToken ?? this.accessToken,
        accessTokenSecret: accessTokenSecret ?? this.accessTokenSecret);
  }

  Map<String, dynamic> toJson() {
    return TwitterAuthKeysSerializer.toMap(this);
  }
}

class FriendListResponse extends _FriendListResponse {
  FriendListResponse({this.previousCursor, this.nextCursor, this.users});

  @override
  final int previousCursor;

  @override
  final int nextCursor;

  @override
  final List<_TwitterUser> users;

  FriendListResponse copyWith(
      {int previousCursor, int nextCursor, List<_TwitterUser> users}) {
    return new FriendListResponse(
        previousCursor: previousCursor ?? this.previousCursor,
        nextCursor: nextCursor ?? this.nextCursor,
        users: users ?? this.users);
  }

  Map<String, dynamic> toJson() {
    return FriendListResponseSerializer.toMap(this);
  }
}

class TwitterUser extends _TwitterUser {
  TwitterUser({this.idStr, this.screenName});

  @override
  final String idStr;

  @override
  final String screenName;

  TwitterUser copyWith({String idStr, String screenName}) {
    return new TwitterUser(
        idStr: idStr ?? this.idStr, screenName: screenName ?? this.screenName);
  }

  Map<String, dynamic> toJson() {
    return TwitterUserSerializer.toMap(this);
  }
}
