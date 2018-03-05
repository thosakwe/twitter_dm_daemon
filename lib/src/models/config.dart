library dm.src.models.config;

import 'package:angel_model/angel_model.dart';
import 'package:angel_serialize/angel_serialize.dart';

part 'config.g.dart';

part 'config.serializer.g.dart';

@Serializable(autoIdAndDateFields: false)
class _Config extends Model {
  List<_TwitterAuthKeys> auth;
  String publicIp;
  int delay;
}

@Serializable(autoIdAndDateFields: false)
class _TwitterAuthKeys {
  String key, secret, accessToken, accessTokenSecret;
}

@Serializable(autoIdAndDateFields: false)
class _FollowerIdsResponse {
  int previousCursor, nextCursor;

  @Exclude(canDeserialize: true)
  List<int> ids;
}

@Serializable(autoIdAndDateFields: false)
class _TwitterUser {
  String idStr, screenName;
}