import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:fe_flutter/src/core/data/models/image.dart';
import 'package:fe_flutter/src/core/data/models/user_setting.dart';
import 'package:fe_flutter/src/core/models/api_models.dart';
import 'package:fe_flutter/src/features/chat/models/chat_message.dart';

part 'serializers.g.dart';

@SerializersFor([
  ImageAsset,
  UserSetting,
  SearchRequest,
  SearchPreferences,
  SearchResponse,
  DocumentFile,
  UploadResponse,
  ChatMessage,
])
final Serializers serializers =
    (_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
