abstract class FromJSONMapper<T> {
  T fromJson(dynamic json);
}

abstract class ToJSONMapper<T> {
  dynamic toJson(T object);
}

abstract class JSONMapper<T> implements FromJSONMapper<T>, ToJSONMapper<T> {}
