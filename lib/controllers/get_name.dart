import 'dart:async';

class GetName extends Close {
  StreamController<String> name =  StreamController<String>();

  Stream<String> get getName => name.stream;
  StreamSink<String> get setName => name.sink;
  Stream<String> namea(String name) async* {
    yield name;
  }

  @override
  dispose() {
    name.close();
  }
}

abstract class Close {
  dispose();
}
