abstract class ToMapper<From, To> {
  To toData(From json);
}

abstract class FromMapper<From, To> {
  To fromData(From json);
}

abstract class FromJSONMapper<T> {
  T fromJson(dynamic json);
}

abstract class ToJSONMapper<T> {
  dynamic toJson(T object);
}

abstract class JSONMapper<T> implements FromJSONMapper<T>, ToJSONMapper<T> {}
