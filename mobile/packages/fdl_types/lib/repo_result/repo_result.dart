class RepoResult<T> {
  final T data;
  final String? message;

  const RepoResult({required this.data, this.message});
}
