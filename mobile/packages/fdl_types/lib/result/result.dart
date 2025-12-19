import 'package:fdl_types/exception/exception.dart';
import 'package:fdl_types/repo_result/repo_result.dart';
import 'package:equatable/equatable.dart';

sealed class Resource<T> extends Equatable {
  const Resource();
}

class Success<T> extends Resource<T> {
  final T data;
  final String message;

  const Success({required this.data, this.message = ''});

  @override
  List<Object?> get props => [data, message];
}

class Failure<T> extends Resource<T> {
  final BaseException exception;

  const Failure({required this.exception});

  @override
  List<Object?> get props => [exception];
}

extension RepoResultExt<T> on Future<RepoResult<T>> {
  Future<Resource<T>> get asResource async {
    final result = await this;
    return Success(data: result.data);
  }
}
