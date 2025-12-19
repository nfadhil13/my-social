import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class BlocProviderWrapper<T extends StateStreamableSource<Object?>>
    extends StatelessWidget {
  const BlocProviderWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<T>(
      create: createBloc,
      child: Builder(
        builder: (context) => buildChild(context, context.read<T>()),
      ),
    );
  }

  Widget buildChild(BuildContext context, T bloc);

  T createBloc(BuildContext context);
}
