
//ref https://wamp-proto.org/wamp_latest_ietf.html#messages
enum WampMessageType {
  /*welcome(0),
  prefix(1),
  call(2),
  callResult(3),
  callError(4),
  subscribe(5),
  unsubscribe(6),
  publish(7),
  event(8),*/
  hello(1),
  welcome(2),
  abort(3),
  challenge(4),
  authenticate(5),
  goodbye(6),
  error(8),
  publish(16),
  published(17),
  subscribe(32),
  subscribed(33),
  unsubscribe(34),
  unsubscribed(35),
  event(36),
  call(48),
  cancel(49),
  result(50),
  register(64),
  registered(65),
  unregister(66),
  unregistered(67),
  invocation(68),
  interrupt(69),
  yield(70),
  unknown(-1);

  final int messageID;

  const WampMessageType(this.messageID);
}

class WampMessageTypeHelper {
  static WampMessageType getMessageType(int id) {
    var type = WampMessageType.values.firstWhere(
        (element) => id == element.messageID,
        orElse: () => WampMessageType.unknown);
    return type;
  }
}
