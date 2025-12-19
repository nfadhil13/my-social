import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:fdl_types/fdl_types.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'cubit_state.dart';
part 'get_cubit_with_params.dart';

abstract class GetDataCubit<Data> extends Cubit<CubitState<Data>> {
  GetDataCubit({CubitState<Data> initialState = const CubitState.loading()})
    : super(initialState);

  Future<Resource<Data>> usecaseCall();

  Future<void> loadData() async {
    emit(const CubitState.loading());
    final result = await usecaseCall();
    switch (result) {
      case Success():
        emit(
          CubitState.success(
            data: result.data,
            isRefreshing: false,
            message: result.message,
          ),
        );
      case Failure():
        emit(CubitState.error(exception: result.exception, onRetry: loadData));
    }
  }

  Future<void> refresh({bool isSilent = false}) async {
    final state = this.state;
    if (state is! CubitSuccessState<Data>) return;
    if (!isSilent) emit(state.toggleRefresh(true));
    final result = await usecaseCall();
    switch (result) {
      case Success():
        emit(
          CubitState.success(
            data: result.data,
            isRefreshing: false,
            message: result.message,
          ),
        );
      case Failure():
        if (isSilent) return;
        emit(CubitState.error(exception: result.exception, onRetry: loadData));
    }
  }

  @override
  void emit(CubitState<Data> state) {
    super.emit(state);
    onLoading(state is CubitLoadingState<Data>);
    onRefresh(state is CubitSuccessState<Data> && state.isRefreshing);
  }

  void onRefresh(bool isRefreshing) {}

  void onLoading(bool isLoading) {}
}
