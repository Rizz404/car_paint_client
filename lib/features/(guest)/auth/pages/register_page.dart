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
import 'package:paint_car/features/(guest)/auth/pages/login_page.dart';
import 'package:paint_car/ui/shared/main_elevated_button.dart';
import 'package:paint_car/ui/shared/main_text.dart';
import 'package:paint_car/ui/shared/main_text_field.dart';
import 'package:paint_car/ui/validator/email_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const RegisterPage());
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late final CancelToken _cancelToken;
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool obscurePassword = false;
  bool obscureConfirmPassword = false;

  @override
  void initState() {
    super.initState();
    _cancelToken = CancelToken();
    setState(() {
      usernameController.text = Mock.user["username"];
      emailController.text = Mock.user["email"];
      passwordController.text = Mock.user["password"];
      confirmPasswordController.text = Mock.user["password"];
    });
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void signUp() async {
    if (formKey.currentState!.validate() &&
        context.read<AuthCubit>().state is! BaseLoadingState) {
      context.read<AuthCubit>().register(
            usernameController.text,
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
          onRetry: signUp,
          onSuccess: () async {
            await context.read<UserCubit>().getUserLocal();
            if (context.mounted) {
              Navigator.of(context)
                  .pushAndRemoveUntil(LoginPage.route(), (_) => false);
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
                        const MainText(text: "Sign Up", extent: ExtraLarge()),
                        const SizedBox(height: 32),
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              MainTextField(
                                controller: usernameController,
                                hintText: "Username",
                                leadingIcon: const Icon(Icons.person),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Username is required";
                                  }
                                  return null;
                                },
                                isEnabled: state is! BaseLoadingState,
                              ),
                              const SizedBox(height: 16),
                              MainTextField(
                                controller: emailController,
                                hintText: "Email",
                                leadingIcon: const Icon(Icons.email),
                                validator: EmailValidator.validate,
                                isEnabled: state is! BaseLoadingState,
                              ),
                              const SizedBox(height: 16),
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
                              const SizedBox(height: 16),
                              MainTextField(
                                controller: confirmPasswordController,
                                hintText: "Confirm Password",
                                leadingIcon: const Icon(Icons.lock),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Confirm Password is required";
                                  }
                                  if (value != passwordController.text) {
                                    return "Password does not match";
                                  }
                                  return null;
                                },
                                trailingIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      obscureConfirmPassword =
                                          !obscureConfirmPassword;
                                    });
                                  },
                                  icon: Icon(
                                    obscureConfirmPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                ),
                                obscureText: !obscureConfirmPassword,
                                isEnabled: state is! BaseLoadingState,
                              ),
                              const SizedBox(height: 24),
                              MainElevatedButton(
                                onPressed: signUp,
                                text: "Sign Up",
                                isLoading: state is BaseLoadingState,
                                bgColor: getButtonColor(),
                                height: 52,
                                borderRadius: 40,
                                extent: const Large(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(LoginPage.route());
                          },
                          child: RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodyMedium,
                              text: "Already have an account? ",
                              children: [
                                const TextSpan(
                                  text: "Sign In",
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
