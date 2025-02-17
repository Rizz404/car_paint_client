import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:paint_car/data/models/car_brand.dart';
import 'package:paint_car/data/models/user_model.dart';
import 'package:paint_car/data/models/user_profile_model.dart';
import 'package:paint_car/dependencies/helper/base_state.dart';
import 'package:paint_car/dependencies/services/log_service.dart';
import 'package:paint_car/features/(guest)/auth/pages/login_page.dart';
import 'package:paint_car/features/(superadmin)/car/cubit/car_brands_cubit.dart';
import 'package:paint_car/features/(superadmin)/car/widgets/image_car_action.dart';
import 'package:paint_car/features/(user)/profile/cubit/profile_cubit.dart';
import 'package:paint_car/features/shared/cubit/user_cubit.dart';
import 'package:paint_car/features/shared/utils/cancel_token.dart';
import 'package:paint_car/features/shared/utils/handle_form_listener_state.dart';
import 'package:paint_car/ui/common/extent.dart';
import 'package:paint_car/ui/shared/main_app_bar.dart';
import 'package:paint_car/ui/shared/main_elevated_button.dart';
import 'package:paint_car/ui/shared/main_text.dart';
import 'package:paint_car/ui/shared/main_text_field.dart';
import 'package:paint_car/ui/utils/snack_bar.dart';
import 'package:paint_car/ui/utils/url_to_file.dart';
import 'package:paint_car/ui/validator/file_validator.dart';
import 'package:paint_car/ui/validator/number_validator.dart';

class ProfilePage extends StatefulWidget {
  final UserWithProfile user;
  const ProfilePage({super.key, required this.user});
  static route({
    required UserWithProfile user,
  }) =>
      MaterialPageRoute(
        builder: (context) => ProfilePage(
          user: user,
        ),
      );
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final CancelToken _cancelToken;
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final fullnameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final addressController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _cancelToken = CancelToken();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      usernameController.text = widget.user.username;
      emailController.text = widget.user.email;
      fullnameController.text = widget.user.userProfile?.fullname ?? "";
      phoneNumberController.text = widget.user.userProfile?.phoneNumber ?? "";
      addressController.text = widget.user.userProfile?.address ?? "";

      _loadImage();
    });
  }

  @override
  void dispose() {
    _cancelToken.cancel();
    _selectedImage?.delete();
    _selectedImage = null;

    usernameController.dispose();
    emailController.dispose();
    fullnameController.dispose();
    phoneNumberController.dispose();
    addressController.dispose();

    super.dispose();
  }

  Future<void> _loadImage() async {
    final profile = widget.user.profileImage;
    try {
      final file = await urlToFile(profile);
      setState(() {
        _selectedImage = file;
      });
    } catch (e) {
      // TODO: DELETE LATERR
      LogService.e("Error loading image: $e");
    }
  }

  void _performAction() {
    context.read<ProfileCubit>().updateUser(
          UserWithProfile(
            id: widget.user.id,
            username: usernameController.text,
            email: emailController.text,
            profileImage: _selectedImage!.path,
            role: widget.user.role,
            userProfile: UserProfile(
              id: widget.user.userProfile?.id ?? "",
              userId: widget.user.id,
              fullname: fullnameController.text,
              phoneNumber: phoneNumberController.text,
              address: addressController.text,
            ),
          ),
          _selectedImage!,
          _cancelToken,
        );
  }

  void submitForm() {
    if (formKey.currentState!.validate() && _selectedImage != null) {
      _performAction();
    } else if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an image")),
      );
      SnackBarUtil.showSnackBar(
        context: context,
        message: "Please select an image",
        type: SnackBarType.error,
      );
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (pickedFile != null) {
        final fileSize = await File(pickedFile.path).length();
        fileValidatorSize(context, fileSize);
        setState(() => _selectedImage = File(pickedFile.path));
      }
    } on PlatformException catch (e) {
      // TODO: DELETE LATERR

      LogService.e("Error picking image: $e");
      SnackBarUtil.showSnackBar(
        context: context,
        message: "Something went wrong picking image",
        type: SnackBarType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, BaseState>(
      listener: (context, state) {
        handleFormListenerState(
          context: context,
          state: state,
          onRetry: submitForm,
          onSuccess: () {
            SnackBarUtil.showSnackBar(
              context: context,
              message: "Profile updated successfully",
              type: SnackBarType.success,
            );
            context.read<UserCubit>().logout();
            Navigator.of(context)
                .pushAndRemoveUntil(LoginPage.route(), (_) => false);
          },
        );
      },
      builder: (context, state) {
        return Scaffold(
          appBar: mainAppBar(
            "User Profile",
          ),
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  spacing: 16,
                  children: [
                    const MainText(
                      text: "Update User PRofile",
                      extent: const Large(),
                    ),
                    ImageCarAction(
                      selectedImage: _selectedImage,
                      logoUrl: widget.user.profileImage,
                      onPickImage: _pickImage,
                    ),
                    MainTextField(
                      controller: usernameController,
                      hintText: "Enter username",
                      leadingIcon: const Icon(Icons.person),
                      isEnabled: state is! BaseLoadingState,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Username cannot be empty";
                        }
                        return null;
                      },
                    ),
                    MainTextField(
                      controller: emailController,
                      hintText: "Enter email",
                      leadingIcon: const Icon(Icons.email),
                      isEnabled: state is! BaseLoadingState,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email cannot be empty";
                        }
                        return null;
                      },
                    ),
                    MainTextField(
                      controller: fullnameController,
                      hintText: "Enter fullname",
                      leadingIcon: const Icon(Icons.person),
                      isEnabled: state is! BaseLoadingState,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Fullname cannot be empty";
                        }
                        return null;
                      },
                    ),
                    MainTextField(
                      controller: phoneNumberController,
                      hintText: "Enter phone number",
                      leadingIcon: const Icon(Icons.phone),
                      isEnabled: state is! BaseLoadingState,
                      validator: numberValidator,
                      keyboardType: TextInputType.phone,
                    ),
                    MainTextField(
                      controller: addressController,
                      hintText: "Enter address",
                      leadingIcon: const Icon(Icons.home),
                      isEnabled: state is! BaseLoadingState,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Address cannot be empty";
                        }
                        return null;
                      },
                    ),
                    MainElevatedButton(
                      onPressed: submitForm,
                      text: "Update",
                      isLoading: state is BaseLoadingState,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
