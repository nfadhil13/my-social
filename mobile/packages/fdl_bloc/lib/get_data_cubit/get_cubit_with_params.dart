part of 'get_cubit.dart';

class GetDataCubitWithParamsData<T, Params> extends Equatable {
  final T data;
  final Params params;

  const GetDataCubitWithParamsData({required this.data, required this.params});

  @override
  List<Object?> get props => [data, params];
}

typedef CubitWithParamsState<T, Params> =
    CubitState<GetDataCubitWithParamsData<T, Params>>;

typedef CubitWithParamsSuccess<T, Params> =
    CubitSuccessState<GetDataCubitWithParamsData<T, Params>>;

typedef CubitWithParamsError<T, Params> =
    CubitErrorState<GetDataCubitWithParamsData<T, Params>>;

typedef CubitWithParamsLoading<T, Params> =
    CubitLoadingState<GetDataCubitWithParamsData<T, Params>>;

abstract class GetDataCubitWithParams<T, Params>
    extends Cubit<CubitWithParamsState<T, Params>> {
  GetDataCubitWithParams({
    CubitWithParamsState<T, Params> initialState = const CubitState.loading(),
  }) : super(initialState);

  Future<Resource<T>> usecaseCall(Params params);

  Future<void> loadData(Params params) async {
    emit(const CubitState.loading());
    final result = await usecaseCall(params);
    switch (result) {
      case Success():
        emit(
          CubitState.success(
            data: GetDataCubitWithParamsData(data: result.data, params: params),
            message: result.message,
          ),
        );
      case Failure():
        emit(
          CubitState.error(
            exception: result.exception,
            onRetry: () => loadData(params),
          ),
        );
    }
  }

  void refresh({bool isSilent = false}) async {
    final state = this.state;
    if (state is! CubitWithParamsSuccess<T, Params>) {
      return;
    }
    if (isSilent) emit(state.toggleRefresh(true));
    if (!isSilent) emit(const CubitState.loading());
    final result = await usecaseCall(state.data.params);
    switch (result) {
      case Success():
        emit(
          CubitState.success(
            message: result.message,
            data: GetDataCubitWithParamsData(
              data: result.data,
              params: state.data.params,
            ),
            isRefreshing: false,
          ),
        );
      case Failure():
        if (isSilent) return;
        emit(
          CubitState.error(
            exception: result.exception,
            onRetry: () => refresh(isSilent: isSilent),
          ),
        );
    }
  }

  @override
  void emit(CubitWithParamsState<T, Params> state) {
    super.emit(state);
    onLoading(state is CubitWithParamsLoading<T, Params>);
    onRefresh(state is CubitWithParamsSuccess<T, Params> && state.isRefreshing);
  }

  void onRefresh(bool isRefreshing) {}

  void onLoading(bool isLoading) {}
}
