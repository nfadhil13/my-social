import 'package:fdl_bloc/fdl_bloc.dart';
import 'package:fdl_ui/fdl_ui.dart';
import 'package:my_social/core/ext/local.dart';
import 'package:my_social/core/router/router.dart';
import 'package:my_social/core/localization/i18n/strings.g.dart';
import 'package:my_social/core/service_locator/service_locator.dart';
import 'package:my_social/features/auth/domain/entities/login_form.dart';
import 'package:my_social/features/auth/presentation/cubits/login/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends BlocProviderWrapper<LoginCubit> {
  const LoginPage({super.key});

  @override
  Widget buildChild(BuildContext context, LoginCubit bloc) {
    final colors = context.colors;
    final formContent = _FormContent();
    return FDLLoadingContainer(
      initialValue: bloc.state.isLoading,
      isLoadingStream: bloc.stream.map((state) => state.isLoading),
      child: Scaffold(
        backgroundColor: colors.background,
        body: BreakPointWidget(
          xs: ColoredBox(
            color: colors.surface,
            child: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: formContent,
                ),
              ),
            ),
          ),
          sm: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: FDLCardContainer(maxWidth: 400, child: formContent),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  LoginCubit createBloc(BuildContext context) => getIt<LoginCubit>();
}

class _FormContent extends StatelessWidget {
  const _FormContent();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final loginCubit = context.read<LoginCubit>();
    final textStyles = context.textStyles;
    final t = Translations.of(context);
    return FDLForm(
      initialData: LoginFormEntity(),
      onSubmit: (submitResult) {
        loginCubit.login(submitResult.value);
      },
      child: Builder(
        builder: (context) {
          final form = context.fdlForm<LoginFormEntity>();
          return BlocListener<LoginCubit, LoginCubitState>(
            listener: (context, state) {
              if (state is LoginCubitSubmitSuccess) {
                context.showSuccessSnackbar(context.translations.loginSuccess);
                context.go(AppRoutes.home);
              }
              if (state is LoginCubitSubmitError) {
                form.setError(state.errors, notify: true);
                context.showErrorSnackbar(
                  context.localizeMessage(state.exception.message),
                );
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  t.welcomeBack,
                  style: textStyles.h1.bold.applyColor(colors.onSurface),
                ),
                const SizedBox(height: 8),
                Text(
                  t.signInToContinue,
                  style: textStyles.p.applyColor(colors.onSurfaceMuted),
                ),
                const SizedBox(height: 32),
                FDLTextField(
                  label: t.emailAddress,
                  hint: t.emailPlaceholder,
                  onSaved: (value) => form.value.email = value ?? '',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => form.errors('email')?.firstOrNull,
                ),
                const SizedBox(height: 24),
                FDLPasswordField(
                  label: t.password,
                  onSaved: (value) => form.value.password = value ?? '',
                  hint: "********",
                  validator: (value) => form.errors('password')?.firstOrNull,
                ),
                const SizedBox(height: 32),
                FDLFilledButton(
                  text: t.signIn,
                  width: double.infinity,
                  onPressed: () => form.submit(),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        t.dontHaveAccount,
                        style: textStyles.p.applyColor(colors.onSurface),
                      ),
                      const SizedBox(width: 4),
                      FDLTextButton(
                        text: t.createAccount,
                        onPressed: () => context.push(AppRoutes.register),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
