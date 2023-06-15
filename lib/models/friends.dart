import 'package:dart_mappable/dart_mappable.dart';

import 'friend.dart';

part 'friends.mapper.dart';

@MappableClass()
class Friends with FriendsMappable {
  final List<Friend> friends;

  Friends({required this.friends});

  static bool friendExists(Friends friends, Friend friend) {
    for (var friend in friends.friends) {
      if (friend.name.toLowerCase().compareTo(friend.name.toLowerCase()) == 0) {
        return true;
      }
    }
    return false;
  }

  static bool friendNameExistsInList(
      List<Friend> friendsList, String friendName) {
    for (var element in friendsList) {
      if (element.name.toLowerCase().compareTo(friendName.toLowerCase()) == 0) {
        return true;
      }
    }
    return false;
  }
}
