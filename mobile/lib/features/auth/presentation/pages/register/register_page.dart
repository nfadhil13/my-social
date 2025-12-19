import 'package:fdl_bloc/fdl_bloc.dart';
import 'package:fdl_ui/fdl_ui.dart';
import 'package:my_social/core/ext/local.dart';
import 'package:my_social/core/router/router.dart';
import 'package:my_social/core/service_locator/service_locator.dart';
import 'package:my_social/core/localization/i18n/strings.g.dart';
import 'package:my_social/features/auth/domain/entities/register_form.dart';
import 'package:my_social/features/auth/presentation/cubits/register/register_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RegisterPage extends BlocProviderWrapper<RegisterCubit> {
  const RegisterPage({super.key});

  @override
  Widget buildChild(BuildContext context, RegisterCubit bloc) {
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
  RegisterCubit createBloc(BuildContext context) => getIt<RegisterCubit>();
}

class _FormContent extends StatelessWidget {
  const _FormContent();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final registerCubit = context.read<RegisterCubit>();
    final textStyles = context.textStyles;
    final t = Translations.of(context);
    return FDLForm(
      initialData: RegisterFormEntity(),
      onSubmit: (submitResult) {
        registerCubit.register(submitResult.value);
      },
      child: Builder(
        builder: (context) {
          final form = context.fdlForm<RegisterFormEntity>();
          return BlocListener<RegisterCubit, RegisterState>(
            listener: (context, state) {
              if (state is RegisterSuccess) {
                context.showSuccessSnackbar(
                  context.translations.registerSuccess,
                );
                context.go(AppRoutes.home);
              }
              if (state is RegisterError) {
                form.setError(state.errors);
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
                  t.createYourAccount,
                  style: textStyles.h1.bold.applyColor(colors.onSurface),
                ),
                const SizedBox(height: 8),
                const SizedBox(height: 32),
                FDLTextField(
                  label: t.fullName,
                  hint: t.fullNamePlaceholder,
                  onSaved: (value) => form.value.fullName = value ?? '',
                  validator: (value) => form.errors('fullName'),
                ),
                const SizedBox(height: 24),
                FDLTextField(
                  label: t.emailAddress,
                  hint: t.emailPlaceholder,
                  onSaved: (value) => form.value.email = value ?? '',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => form.errors('email'),
                ),
                const SizedBox(height: 24),
                FDLPasswordField(
                  label: t.password,
                  onSaved: (value) => form.value.password = value ?? '',
                  hint: "********",
                  validator: (value) => form.errors('password'),
                ),
                const SizedBox(height: 24),
                FDLPasswordField(
                  label: t.confirmPassword,
                  onSaved: (value) => form.value.confirmPassword = value ?? '',
                  hint: "********",
                  validator: (value) => form.errors('confirmPassword'),
                ),
                const SizedBox(height: 32),
                FDLFilledButton(
                  text: t.createAccount,
                  width: double.infinity,
                  onPressed: () => form.submit(),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        t.alreadyHaveAccount,
                        style: textStyles.p.applyColor(colors.onSurface),
                      ),
                      const SizedBox(width: 4),
                      FDLTextButton(
                        text: t.signIn,
                        onPressed: () => context.push(AppRoutes.login),
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
