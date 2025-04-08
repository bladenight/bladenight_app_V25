class WampRpc<T> {
  Exception? rpcException;
  final timeStamp = DateTime.now();

  rpcError(Exception wampResult) {
    rpcException = wampResult;
  }
}
