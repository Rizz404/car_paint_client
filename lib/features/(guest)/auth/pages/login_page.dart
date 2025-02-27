import 'package:flutter/material.dart';
import 'package:paint_car/core/constants/custom_colors.dart';
import 'package:paint_car/core/constants/mock.dart';
import 'package:paint_car/features/(guest)/auth/widgets/gradient_bg_auth.dart';
import 'package:paint_car/features/shared/cubit/user_cubit.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';
import 'package:paint_car/features/shared/utils/handle_form_listener_state.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/features/(guest)/auth/cubit/auth_cubit.dart';
import 'package:paint_car/features/(guest)/auth/pages/register_page.dart';
import 'package:paint_car/features/home/pages/home_page.dart';
import 'package:paint_car/ui/shared/main_elevated_button.dart';
import 'package:paint_car/ui/shared/main_text.dart';
import 'package:paint_car/ui/shared/main_text_field.dart';
import 'package:paint_car/ui/validator/email_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const LoginPage());
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final CancelToken _cancelToken;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool obscurePassword = false;
  bool obscureConfirmPassword = false;

  @override
  void initState() {
    super.initState();
    _cancelToken = CancelToken();
    setState(() {
      emailController.text = Mock.user["email"];
      passwordController.text = Mock.user["password"];
    });
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void signIn() async {
    if (formKey.currentState!.validate() &&
        context.read<AuthCubit>().state is! BaseLoadingState) {
      context.read<AuthCubit>().login(
            emailController.text,
            passwordController.text,
            _cancelToken,
          );
    }
  }

  Color getButtonColor() {
    if (context.read<AuthCubit>().state is BaseLoadingState) {
      return Theme.of(context).disabledColor;
    } else {
      return CustomColors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, BaseState>(
      listener: (context, state) {
        handleFormListenerState(
          context: context,
          state: state,
          onRetry: signIn,
          onSuccess: () async {
            await context.read<UserCubit>().getUserLocal();
            if (context.mounted) {
              Navigator.of(context)
                  .pushAndRemoveUntil(HomePage.route(), (_) => false);
            }
          },
        );
      },
      builder: (context, state) {
        return Scaffold(
          body: GradientBgAuth(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: SingleChildScrollView(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.onPrimary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const MainText(text: "Sign In", extent: ExtraLarge()),
                        const SizedBox(height: 32),
                        Form(
                          key: formKey,
                          child: Column(
                            spacing: 16,
                            children: [
                              MainTextField(
                                controller: emailController,
                                hintText: "Email",
                                leadingIcon: const Icon(Icons.email),
                                validator: EmailValidator.validate,
                                isEnabled: state is! BaseLoadingState,
                              ),
                              MainTextField(
                                controller: passwordController,
                                hintText: "Password",
                                leadingIcon: const Icon(Icons.lock),
                                trailingIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      obscurePassword = !obscurePassword;
                                    });
                                  },
                                  icon: Icon(
                                    obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                ),
                                obscureText: !obscurePassword,
                                isEnabled: state is! BaseLoadingState,
                              ),
                              MainElevatedButton(
                                onPressed: signIn,
                                text: "Sign In",
                                isLoading: state is BaseLoadingState,
                                bgColor: getButtonColor(),
                                height: 52,
                                borderRadius: 32,
                                extent: const Large(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(RegisterPage.route());
                          },
                          child: RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodyMedium,
                              text: "Does'nt have an account? ",
                              children: [
                                const TextSpan(
                                  text: "Sign Up",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.underline,
                                    decorationColor: CustomColors.black,
                                    color: CustomColors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
