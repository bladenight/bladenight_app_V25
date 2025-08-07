import 'package:dart_mappable/dart_mappable.dart';

part 'relationship_input.mapper.dart';

@MappableClass()
class RelationshipInputMessage with RelationshipInputMessageMappable{
  @MappableField(key: 'did')
  late final String deviceId;
  @MappableField(key: 'fid')
  late final int friendId;
  @MappableField(key: 'req')
  late final int requestId;

  RelationshipInputMessage({
    required this.deviceId,
    required this.friendId,
    required this.requestId,
  });
}

///Create relationship
//@MappableClass()
class CreateRelationshipMessage extends RelationshipInputMessage {
  CreateRelationshipMessage({required super.deviceId, required super.friendId})
      : super(requestId: 0);
}

///Finalize relationship with 6-digit code
//@MappableClass()
class FinalizeRelationshipMessage extends RelationshipInputMessage {
  FinalizeRelationshipMessage(
      {required super.deviceId, required super.friendId, required super.requestId});
}

///Delete relationship
//@MappableClass()
class DeleteRelationshipMessage extends RelationshipInputMessage {
  DeleteRelationshipMessage(
      {required super.deviceId, required super.friendId, required super.requestId});
}

@MappableClass()
class GetFriendsListMessage extends RelationshipInputMessage with GetFriendsListMessageMappable{
  GetFriendsListMessage(
      {required String deviceid, required int friendid, required int requestid})
      : super(deviceId: deviceid, friendId: friendid, requestId: requestid);
}

///Type of mode on routing to FriendPage
enum FriendMessageType { addFriend, validateFriend, deleteFriend, editFriend }
